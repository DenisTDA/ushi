class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise  :database_authenticatable,
          :registerable,
          :recoverable,
          :rememberable,
          :validatable

  has_many :replies, class_name: 'Answer', foreign_key: :author_id
  has_many :problems, class_name: 'Question', foreign_key: :author_id

  def author?(author_id)
    id.eql?(author_id)
  end
end
