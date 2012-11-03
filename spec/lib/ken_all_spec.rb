#coding: utf-8
require 'spec_helper'

describe KenAll::Import do
  let(:obj){KenAll::Import.new}
  describe :run do
    before do
      mock(obj).download_file(anything){nil}
      mock(obj).zip_to_csv(anything){nil}
      mock(obj).import_model(anything){nil}
    end
    it "メソッドが実行できること" do
      obj.run
    end
  end

  describe :import_model do
    let(:csv) do
      CSV.parse <<EOS
01224,"066  ","0660075","ﾎｯｶｲﾄﾞｳ","ﾁﾄｾｼ","ｷﾀｼﾅﾉ","北海道","千歳市","北信濃",0,0,0,0,0,0
01224,"066  ","0660005","ﾎｯｶｲﾄﾞｳ","ﾁﾄｾｼ","ｷｮｳﾜ(88-2､271-10､343-2､404-1､427-","北海道","千歳市","協和（８８−２、２７１−１０、３４３−２、４０４−１、４２７−",1,0,0,0,0,0
01224,"066  ","0660005","ﾎｯｶｲﾄﾞｳ","ﾁﾄｾｼ","3､431-12､443-6､608-2､641-8､814､842-","北海道","千歳市","３、４３１−１２、４４３−６、６０８−２、６４１−８、８１４、８４２−",1,0,0,0,0,0
01224,"066  ","0660005","ﾎｯｶｲﾄﾞｳ","ﾁﾄｾｼ","5､1137-3､1392､1657､1752ﾊﾞﾝﾁ)","北海道","千歳市","５、１１３７−３、１３９２、１６５７、１７５２番地）",1,0,0,0,0,0
01224,"06911","0691182","ﾎｯｶｲﾄﾞｳ","ﾁﾄｾｼ","ｷｮｳﾜ(ｿﾉﾀ)","北海道","千歳市","協和（その他）",1,0,0,0,0,0
EOS
    end
    before do
      obj.import_model(csv)
    end
    it "3レコード取り込まれること" do
      KenAll::PostalCode.scoped.size.should == 3
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
end