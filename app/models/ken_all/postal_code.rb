module KenAll
  class PostalCode < ActiveRecord::Base
    validates :code, :presence => true
    if Rails.version.to_i == 3
      attr_accessible :code, :address1, :address2, :address3,
        :address_kana1, :address_kana2, :address_kana3
    end
  end
end
