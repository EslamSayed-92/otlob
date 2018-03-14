class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
   
  has_and_belongs_to_many :groups
  has_many :friendships
  has_many :invitations
  has_many :orders
  has_many :friends, :through => :friendships
  has_many :inverse_friendships, :class_name => "Friendship", :foreign_key => "friend_id"
  has_many :inverse_friends, :through => :inverse_friendships, :source => :user

  # Include default devise modules. Others available are:
  
  # Include User Image using paperclip
  has_attached_file :avatar, styles: { large:"500x500>", medium: "300x300#", thumb: "100x100#" }
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\z/
 
  # :confirmable, :lockable, :timeoutable and :omniauthable
  

   validates :name, presence: true,
                    length: { minimum: 3 }

  validates :email, uniqueness: true,
                    length: { minimum: 3 }
   validates :email, format: { with: /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i,
    message: "please enter valid email" }

end
