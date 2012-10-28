# coding: utf-8
require 'spec_helper'

describe KenAll::PostalCode do
  context "正常なデータの場合" do
    let(:postal_code){KenAll::PostalCode.new(:code => "7000823", :address1 => "岡山県", :address2 => "岡山市",
                                     :address3 => "丸の内", :address_kana1 => "ｵｶﾔﾏｹﾝ", :address_kana2 => "ｵｶﾔﾏｼｷﾀｸ",
                                     :address_kana3 => "ﾏﾙﾉｳﾁ")}
    it "バリデーションが成功すること" do
      postal_code.should be_valid
    end
  end
  context "異常なデータの場合" do
    let(:postal_code){KenAll::PostalCode.new(:code => nil, :address1 => "岡山県", :address2 => "岡山市",
                                     :address3 => "丸の内", :address_kana1 => "ｵｶﾔﾏｹﾝ", :address_kana2 => "ｵｶﾔﾏｼｷﾀｸ",
                                     :address_kana3 => "ﾏﾙﾉｳﾁ")}
    it "バリデーションが失敗すること" do
      postal_code.should_not be_valid
    end
  end
end
