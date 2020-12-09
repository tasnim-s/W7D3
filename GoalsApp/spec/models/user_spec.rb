require 'rails_helper'

RSpec.describe User, type: :model do

  subject(:user) do
    FactoryBot.build(:user)
  end

  # pending "add some examples to (or delete) #{__FILE__}"
    it {should validate_presence_of(:username)}
    it {should validate_presence_of(:password_digest)}
    it {should validate_presence_of(:session_token)}
    it {should validate_length_of(:password).is_at_least(6)}

    it 'create a password_digest when password is given' do
      expect(user.password_digest).to_not be_nil
    end

    it 'create a session_token before validation' do
      user.valid?
      expect(user.session_token).to_not be_nil
    end

  describe '.find_by_credentials' do
    before {user.save!}

    it 'return user given credentials' do
      expect(User.find_by_credentials(user.username, "onering")).to eq(user)
    end

    it 'should return nil given bad credentials' do
      expect(User.find_by_credentials(user.username, "password")).to eq(nil)
    end
  end

  describe '#is_password?' do
    it 'verifies a password is correct' do
      expect(user.is_password?("onering")).to be true
    end
    it 'verifies a password is incorrect' do
      expect(user.is_password?("password")).to be false
    end
  end

  describe '#reset_session_token!' do
    it 'sets a new session_token for user' do 
      user.valid?
      old_session_token = user.session_token
      user.reset_session_token!

      expect(user.session_token).to_not eq(old_session_token)
    end
    it 'return new session_token' do
      expect(user.reset_session_token!).to eq(user.session_token)
    end
  end
end
