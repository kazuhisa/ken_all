# This migration comes from ken_all (originally 20130722102956)
class ColumnChangePostalCodes < ActiveRecord::Migration
  def change
    change_column :ken_all_postal_codes, :address1, :text
    change_column :ken_all_postal_codes, :address2, :text
    change_column :ken_all_postal_codes, :address3, :text
    change_column :ken_all_postal_codes, :address_kana1, :text
    change_column :ken_all_postal_codes, :address_kana2, :text
    change_column :ken_all_postal_codes, :address_kana3, :text
  end
end
