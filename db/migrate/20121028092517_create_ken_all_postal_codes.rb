if ActiveRecord.gem_version >= Gem::Version.new('4.2')
  class CreateKenAllPostalCodes < ActiveRecord::Migration[4.2]; end
else
  class CreateKenAllPostalCodes < ActiveRecord::Migration; end
end

CreateKenAllPostalCodes.class_eval do
  def change
    create_table :ken_all_postal_codes do |t|
      t.string :code
      t.string :address1
      t.string :address2
      t.string :address3
      t.string :address_kana1
      t.string :address_kana2
      t.string :address_kana3
      t.timestamps
    end

    add_index :ken_all_postal_codes, :code
  end
end
