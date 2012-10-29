require 'ken_all/engine'
require 'open-uri'
require 'tempfile'
require 'zipruby'
require 'csv'

module KenAll
  class Import
    URI = "http://www.post.japanpost.jp/zipcode/dl/kogaki/zip/ken_all.zip"

    def run
      Tempfile.open("ken_all.zip") do |f|
        download_file(f)
        csv = zip_to_csv(f)
        import_model(csv)
      end
    end

    def download_file(file)
      file.binmode
      open(URI, 'rb') do |read_file|
        file.write(read_file.read)
      end
      file.rewind
    end

    def zip_to_csv(zip_file)
      Zip::Archive.open_buffer(zip_file.read) do |ar|
        ar.fopen(ar.get_name(0)) do |file|
          CSV.parse(file.read.encode("utf-8","sjis"))
        end
      end
    end

    def import_model(csv)
      ActiveRecord::Base.transaction do
        header = [:code, :address1, :address2, :address3, :address_kana1, :address_kana2, :address_kana3]
        list = []
        csv.each do |row|
          list << [row[2],
              row[6],
              row[7],
              row[8],
              row[3],
              row[4],
              row[5]]
        end
        PostalCode.delete_all
        PostalCode.import(header, list)
      end
    end
  end
end
