# coding: utf-8

module KenAll
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
end