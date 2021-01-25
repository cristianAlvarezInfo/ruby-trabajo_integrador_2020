class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :books, dependent: :destroy,inverse_of: :user
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  after_create :create_global_book

  def create_global_book
    books.create title: 'global'
  end

  def global_book 
    return books.where(title: 'global').first
  end

end
