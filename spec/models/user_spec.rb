require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { FactoryBot.create(:user) }

  describe "User" do
    it "有効なファクトリを持つこと" do
      expect(user).to be_valid
    end

    it "名前がなければ無効な状態であること" do
      user.name = nil
      expect(user).not_to be_valid
    end

    it "名前が長すぎると無効な状態であること" do
      user.name = "a" * 51
      expect(user).not_to be_valid
    end

    it "メールアドレスがなければ無効な状態であること" do
      user.email = nil
      expect(user).not_to be_valid
    end

    it "メールアドレスが長すぎると無効な状態であること" do
      user.email = "a" * 244 + "@example.com"
      expect(user).not_to be_valid
    end

    it "重複したメールアドレスなら無効な状態であること" do
      FactoryBot.create(:user, email: "tester@example.com")
      user = FactoryBot.build(:user, email: "tester@example.com")
      user.email.upcase
      user.valid?
      expect(user.errors[:email]).to include("has already been taken")
    end

    it "有効なメールアドレスは有効であること" do
      valid_addresses = %w(user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn)
      valid_addresses.each do |valid_address|
        user.email = valid_address
        expect(user).to be_valid
      end
    end

    it "無効なメールアドレスは無効であること" do
      invalid_addresses = %w(
        user@example,com user_at_foo.org
        user.name@example. foo@bar_baz.com foo@bar+baz.com
      )
      invalid_addresses.each do |invalid_address|
        user.email = invalid_address
        expect(user).not_to be_valid
      end
    end

    it "メールアドレスは小文字で保存されること" do
      mixed_case_email = "Foo@ExAMPle.CoM"
      user.email = mixed_case_email
      user.save
      expect(user.email.downcase).to eq user.reload.email
    end

    it "パスワードは空白では存在できないこと" do
      user.password = user.password_confirmation = "" * 6
      expect(user).not_to be_valid
    end

    it "パスワードは最小の長さが必要であること" do
      user.password = user.password_confirmation = "a" * 5
      expect(user).not_to be_valid
    end

    it "パスワード確認が一致すれば有効であること" do
      user = FactoryBot.build(:user, password: "password", password_confirmation: "password")
      expect(user).to be_valid
    end

    it "パスワード確認が一致しなければ無効であること" do
      user = FactoryBot.build(:user, password: "password", password_confirmation: "different")
      user.valid?
      expect(user).not_to be_valid
    end

    it "住所が長すぎると存在できないこと" do
      user.address = "a" * 151
      expect(user).not_to be_valid
    end

    it "住所がなければ無効であること" do
      user.address = ""
      expect(user).not_to be_valid
    end

    it "電話番号がなければ無効であること" do
      user.phone_number = nil
      expect(user).not_to be_valid
    end

    it "電話番号が数字でなければ無効であること" do
      user.phone_number = "a" * 10
      expect(user).not_to be_valid
    end
  end
end
