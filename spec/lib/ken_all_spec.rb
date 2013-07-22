#coding: utf-8
require 'spec_helper'

describe KenAll::Import do
  let(:obj){KenAll::Import.new(:visualize => false)}

  describe :import_model do
    let(:csv) do
      CSV.parse <<EOS
01101,"060  ","0600000","ﾎｯｶｲﾄﾞｳ","ｻｯﾎﾟﾛｼﾁｭｳｵｳｸ","ｲｶﾆｹｲｻｲｶﾞﾅｲﾊﾞｱｲ","北海道","札幌市中央区","以下に掲載がない場合",0,0,0,0,0,0
01224,"066  ","0660075","ﾎｯｶｲﾄﾞｳ","ﾁﾄｾｼ","ｷﾀｼﾅﾉ","北海道","千歳市","北信濃",0,0,0,0,0,0
01224,"066  ","0660005","ﾎｯｶｲﾄﾞｳ","ﾁﾄｾｼ","ｷｮｳﾜ(88-2､271-10､343-2､404-1､427-","北海道","千歳市","協和（８８−２、２７１−１０、３４３−２、４０４−１、４２７−",1,0,0,0,0,0
01224,"066  ","0660005","ﾎｯｶｲﾄﾞｳ","ﾁﾄｾｼ","3､431-12､443-6､608-2､641-8､814､842-","北海道","千歳市","３、４３１−１２、４４３−６、６０８−２、６４１−８、８１４、８４２−",1,0,0,0,0,0
01224,"066  ","0660005","ﾎｯｶｲﾄﾞｳ","ﾁﾄｾｼ","5､1137-3､1392､1657､1752ﾊﾞﾝﾁ)","北海道","千歳市","５、１１３７−３、１３９２、１６５７、１７５２番地）",1,0,0,0,0,0
01224,"06911","0691182","ﾎｯｶｲﾄﾞｳ","ﾁﾄｾｼ","ｷｮｳﾜ(ｿﾉﾀ)","北海道","千歳市","協和（その他）",1,0,0,0,0,0
13362,"10003","1000301","ﾄｳｷｮｳﾄ","ﾄｼﾏﾑﾗ","ﾄｼﾏﾑﾗｲﾁｴﾝ","東京都","利島村","利島村一円",0,0,0,0,0,0
08546,"30604","3060433","ｲﾊﾞﾗｷｹﾝ","ｻｼﾏｸﾞﾝｻｶｲﾏﾁ","ｻｶｲﾏﾁﾉﾂｷﾞﾆﾊﾞﾝﾁｶﾞｸﾙﾊﾞｱｲ","茨城県","猿島郡境町","境町の次に番地がくる場合",0,0,0,0,0,0
25443,"52203","5220317","ｼｶﾞｹﾝ","ｲﾇｶﾐｸﾞﾝﾀｶﾞﾁｮｳ","ｲﾁｴﾝ","滋賀県","犬上郡多賀町","一円",0,0,0,0,0,0
EOS
    end
    before do
      obj.import_model(csv)
    end
    it "正しく取り込まれること" do
      KenAll::PostalCode.scoped.size.should == 7
    end
    context "以下に掲載がない場合" do
      let(:record){KenAll::PostalCode.find_by_code("0600000")}
      it "address3に空文字列がセットされていること" do
        record.address3.should == ""
      end
      it "address_kana3に空文字列がセットされていること" do
        record.address_kana3.should == ""
      end
    end
    context "境町の次に番地がくる場合" do
      let(:record){KenAll::PostalCode.find_by_code("3060433")}
      it "address3に空文字列がセットされていること" do
        record.address3.should == ""
      end
      it "address_kana3に空文字列がセットされていること" do
        record.address_kana3.should == ""
      end
    end
    context "〜一円" do
      let(:record){KenAll::PostalCode.find_by_code("1000301")}
      it "address3に空文字列がセットされていること" do
        record.address3.should == ""
      end
      it "address_kana3に空文字列がセットされていること" do
        record.address_kana3.should == ""
      end
    end
    context "一円という地名" do
      let(:record){KenAll::PostalCode.find_by_code("5220317")}
      it "address3の修正はされないこと" do
        record.address3.should == "一円"
      end
      it "address_kana3の修正はされないこと" do
        record.address_kana3.should == "ｲﾁｴﾝ"
      end
    end
    context "〒066-0005の住所のマージ" do
      let(:record){KenAll::PostalCode.find_by_code("0660005")}
      it "address3が正しいこと" do
        record.address3.should == "協和（８８−２、２７１−１０、３４３−２、４０４−１、４２７−３、４３１−１２、４４３−６、６０８−２、６４１−８、８１４、８４２−５、１１３７−３、１３９２、１６５７、１７５２番地）"
      end
      it "address_kana3が正しいこと" do
        record.address_kana3.should == "ｷｮｳﾜ(88-2､271-10､343-2､404-1､427-3､431-12､443-6､608-2､641-8､814､842-5､1137-3､1392､1657､1752ﾊﾞﾝﾁ)"
      end
    end
  end

  context 'スキーマ情報が古い場合' do
    before do
      stub(column = Object.new).sql_type{'varchar(255)'}
      stub(KenAll::PostalCode.columns).select{[column]}
    end
    it '例外が発生すること' do
      expect {KenAll::Import.new}.to raise_error
    end
  end
end