class CreateKenAllPostalCodes < ActiveRecord::Migration
  def change
    create_table :ken_all_postal_codes do |t|
      t.string :code
      t.string :address1
      t.string :address2
      t.string :address3
      t.string :address_kana1
      t.string :address_kana2
      t.string :address_kana3, limit: 510
      t.timestamps
    end

    add_index :ken_all_postal_codes, :code
  end
end
