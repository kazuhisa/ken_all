if ActiveRecord.gem_version >= Gem::Version.new('4.2')
  class ColumnChangePostalCodes < ActiveRecord::Migration[4.2]; end
else
  class ColumnChangePostalCodes < ActiveRecord::Migration; end
end

ColumnChangePostalCodes.class_eval do
  def change
    change_column :ken_all_postal_codes, :address1, :text
    change_column :ken_all_postal_codes, :address2, :text
    change_column :ken_all_postal_codes, :address3, :text
    change_column :ken_all_postal_codes, :address_kana1, :text
    change_column :ken_all_postal_codes, :address_kana2, :text
    change_column :ken_all_postal_codes, :address_kana3, :text
  end
end
