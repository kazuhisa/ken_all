# coding: utf-8

module KenAll
  class OldSchemaException < StandardError
  end

  class Import
    URI = "http://www.post.japanpost.jp/zipcode/dl/kogaki/zip/ken_all.zip"

    def initialize(opt = {visualize: true})
      @visualizer = KenAll::Visualizer.new(opt[:visualize])
      if old_schema?
        error = <<EOS
KenAll Error.
This project is using old schema information.
Type First.
$ rake ken_all:install:migrations
$ rake db:migrate
EOS
        raise KenAll::OldSchemaException.new(error)
      end
    end

    def from_net
      @visualizer.screen_init do
        Tempfile.open("ken_all.zip") do |f|
          download_file(f)
          csv = zip_to_csv(f)
          import_model(csv)
        end
      end
    end

    def from_file
      if ENV["FILE"].present?
        if File.extname(ENV["FILE"]).downcase == '.zip'
          import_model zip_to_csv(ENV["FILE"])
        else
          CSV.open(ENV["FILE"],:encoding => "Shift_JIS:UTF-8") do |csv|
            import_model(csv)
          end
        end
      else
        puts "Specify FILE arguments."
        puts "rake ken_all:import:file FILE=/path/to/x-ken-all.csv"
      end
    end

    def download_file(file)
      @visualizer.download_status do
        file.binmode
        open(URI, 'rb') do |read_file|
          file.write(read_file.read)
        end
        file.rewind
      end
    end

    def zip_to_csv(zip_file)
      csv = nil
      @visualizer.unzip_status do
        # Use Zip::File for rubyzip >= 1.0.0, Zip::ZipFile for older.
        klass = defined?(Zip::File) ? Zip::File : Zip::ZipFile
        klass.foreach(zip_file) do |entry|
          File.extname(entry.name).downcase == '.csv' or next
          csv = CSV.parse(entry.get_input_stream.read.encode("utf-8", "sjis"))
          break
        end
      end
      csv
    end

    def import_model(csv)
      @visualizer.import_status do
        ActiveRecord::Base.transaction do
          header = [:code, :address1, :address2, :address3, :address_kana1, :address_kana2, :address_kana3]
          list = []
          merge = MergeBox.new
          csv.each do |row|
            post = Post.new(row)
            if post.adr_start?
              merge.add(post)
            elsif post.adr_end?
              merge.add(post)
              list << merge.to_array
              merge.clear
              next
            elsif merge.count > 0
              merge.add(post)
            else
              list << post.to_array
            end
          end
          KenAll::PostalCode.delete_all
          KenAll::PostalCode.import(header, list)
        end
      end
    end

    def old_schema?
      column = KenAll::PostalCode.columns.select{|v| v.name == 'address1'}.first
      !(column.sql_type =~ /text/)
    end
  end
end
