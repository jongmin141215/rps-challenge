require 'bcrypt'

class User
  include DataMapper::Resource
  attr_reader :name, :password
  attr_accessor :password_confirmation
  validates_confirmation_of :password

  property :id, Serial
  property :name, String, required: true, unique: true
  property :password_digest, Text, required: true

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def self.authenticate(name, password)
    user = User.first(name: name)
    user if (user && (BCrypt::Password.new(user.password_digest) == password))
  end

end
