class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :books, dependent: :destroy,inverse_of: :user
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  after_create :create_book

  def create_book(title='global')
    books.create title: title
  end
end
