class Book < ApplicationRecord
  belongs_to :user, inverse_of: :books
  has_many :notes, dependent: :destroy,inverse_of: :book

  validates :title, presence: true, length: {maximum: 255}

  def to_s
    title
  end
end
