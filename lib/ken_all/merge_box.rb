# coding: utf-8

module KenAll
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