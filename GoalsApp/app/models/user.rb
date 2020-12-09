class User < ApplicationRecord
    validates :username,:password_digest,:session_token, presence:true
    validates :password, length:{minimum:6}, allow_nil:true

    attr_reader :password
    after_initialize :ensure_session_token

    def password=(plain_text_password)
        @password = plain_text_password # so our reader on 24 can access it
        self.password_digest = BCrypt::Password.create(plain_text_password)
        # `create` takes a plaintext password, hashes and salts it, and spits out a digest
    end

    def is_password?(password)
        BCrypt::Password.new(password_digest).is_password?(password)
    end

    def self.find_by_credentials(username, password)
        user = User.find_by(username: username)
        user && user.is_password?(password) ? user : nil
    end

    def generate_session_token
        SecureRandom.urlsafe_base64
    end

    def ensure_session_token
        self.session_token ||= generate_session_token
    end

    def reset_session_token!
        self.session_token = generate_session_token
        session_token
    end



end
