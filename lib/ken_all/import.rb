# coding: utf-8

module KenAll
  class Import
    URI = "http://www.post.japanpost.jp/zipcode/dl/kogaki/zip/ken_all.zip"

    def initialize(opt = {visualize: true})
      @visualizer = KenAll::Visualizer.new(opt[:visualize])
    end

    def run
      @visualizer.screen_init do
        Tempfile.open("ken_all.zip") do |f|
          download_file(f)
          csv = zip_to_csv(f)
          import_model(csv)
        end
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
        Zip::Archive.open_buffer(zip_file.read) do |ar|
          ar.fopen(ar.get_name(0)) do |file|
            csv = CSV.parse(file.read.encode("utf-8","sjis"))
          end
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
          PostalCode.delete_all
          PostalCode.import(header, list)
        end
      end
    end
  end
end