module KenAll
  class PostalCode < ActiveRecord::Base
    attr_accessible :code, :address1, :address2, :address3,
                    :address_kana1, :address_kana2, :address_kana3
    validates :code, :presence => true
  end
end
