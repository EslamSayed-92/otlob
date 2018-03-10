class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
   
  has_and_belongs_to_many :groups

  # Include default devise modules. Others available are:

 
  # :confirmable, :lockable, :timeoutable and :omniauthable
  

   validates :name, presence: true,
                    length: { minimum: 3 }

  validates :email, uniqueness: true,
                    length: { minimum: 3 }
   validates :email, format: { with: /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i,
    message: "please enter valid email" }

end
