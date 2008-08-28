class User < ActiveRecord::Base
  has_and_belongs_to_many :roles

  attr_accessor :password
  attr_accessible :password

  validates_presence_of :username, :message => 'You need to enter a username.'
  validates_format_of :username, :with => /\A[a-z0-9\._-]+\Z/i,
    :message => "Please pick a username using the following characters only: 'a'-'z', '0'-'9', '.', '_' and '-'."
  validates_uniqueness_of :username, :allow_nil => true, :case_sensitive => false,
    :message => 'That username is already taken. Please select another one.'
  validates_presence_of :password, :if => :password_required?, :message => 'Please enter a password.'
  validates_presence_of :password_confirmation, :if => :password_required?, :message => 'Please confirm your password.'
  validates_length_of :password, :within => 4..40, :if => :password_required?,
    :too_short => 'Please pick a password between 4 and 40 characters long.',
    :too_long => 'Please pick a password between 4 and 40 characters long.'
  validates_confirmation_of :password, :if => :password_required?, :message => 'Please confirm your password correctly.'

  before_save :encrypt_password
  after_create :create_roles

  # Authenticates a user by their username and unencrypted password.  Returns the user or nil.
  def self.authenticate(username, password)
    u = find(:first, :conditions => {:username => username}) # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  # Encrypts some data with the salt.
  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end

  # Encrypts the password with the user salt
  def encrypt(password)
    self.class.encrypt(password, salt)
  end

  def authenticated?(password)
    crypted_password == encrypt(password)
  end

  protected
    def encrypt_password
      return if password.blank?
      self[:salt] = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{username}--")
      self[:crypted_password] = encrypt(password)
    end

    def password_required?
      crypted_password.blank? || !password.blank?
    end

    def create_roles
      standard_user_role = Role.find(:conditions => {:name => 'Standard user'})
      roles << standard_user_role
      save
    end
end
