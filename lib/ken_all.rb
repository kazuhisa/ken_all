# coding: utf-8
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

  class Post
    NOT_FOUND = /^以下に掲載がない場合$/
    NEXT_ADDRESS = /^境町の次に番地がくる場合$/
    WHOLE_PLACE = /.+一円$/

    attr_accessor :code, :address1, :address2, :address3, :address_kana1, :address_kana2, :address_kana3
    def initialize(row = nil)
      unless row.nil?
        self.code = row[2]
        self.address1 = row[6]
        self.address2 = row[7]
        self.address3 = row[8]
        self.address_kana1 = row[3]
        self.address_kana2 = row[4]
        self.address_kana3 = row[5]
      end
    end

    def adr_start?
      (self.address3 =~ /（/ && !(self.address3 =~ /）/)) || (self.address_kana3 =~ /\(/ && !(self.address_kana3 =~ /\)/))
    end

    def adr_end?
      (!(self.address3 =~ /（/) && self.address3 =~ /）/) || (!(self.address_kana3 =~ /\(/) && self.address_kana3 =~ /\)/)
    end

    def to_array
      if self.address3 =~ NOT_FOUND || self.address3 =~ NEXT_ADDRESS || self.address3 =~ WHOLE_PLACE
        self.address3 = ""
        self.address_kana3 = ""
      end
      [self.code, self.address1, self.address2, self.address3, self.address_kana1, self.address_kana2, self.address_kana3]
    end
  end

  class MergeBox
    def initialize
      @list = []
    end

    def add(post)
      @list << post
    end

    def clear
      @list = []
    end

    def to_array
      post = Post.new
      post.code = @list[0].code
      post.address1 = @list[0].address1
      post.address2 = @list[0].address2
      post.address3 = @list.inject(""){|str,v| str += v.address3}
      post.address_kana1 = @list[0].address_kana1
      post.address_kana2 = @list[0].address_kana2
      post.address_kana3 = @list.inject(""){|str,v| str += v.address_kana3}
      post.to_array
    end

    def count
      @list.count
    end
  end
end
