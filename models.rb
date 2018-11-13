class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true
end

class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
      record.errors[attribute] << (options[:message] || "is not an email")
    end
  end
end

class User < ApplicationRecord
    has_many :posts
    has_secure_password
    validates :email, :password, presence: true
    validates :password, length: { minimum: 8, maximum: 20 }
    validates :email, uniqueness: true
    validates :email, email: true
end

class Post < ApplicationRecord
    belongs_to :user
    validates :text, presence: true, length: { minimum: 1, maximum: 80 }
    #validates_associated :user
end
    