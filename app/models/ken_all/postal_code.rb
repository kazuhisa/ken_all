module KenAll
  class PostalCode < ActiveRecord::Base
    validates :code, :presence => true

    def postal_code_params
      params.require(:postal_code).permit(
        :code,
        :address1,
        :address2,
        :address3,
        :address_kana1,
        :address_kana2,
        :address_kana3
      )
    end
  end
end
