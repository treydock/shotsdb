# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable

  attr_writer :login

  has_many :brasses, dependent: :destroy
  has_many :bullets, dependent: :destroy
  has_many :calibers, dependent: :destroy
  has_many :loads, dependent: :destroy
  has_many :powders, dependent: :destroy
  has_many :primers, dependent: :destroy
  has_many :guns, dependent: :destroy
  has_many :shooting_locations, dependent: :destroy
  has_many :shooting_logs, dependent: :destroy
  has_many :shooting_groups, dependent: :destroy
  has_many :shooting_velocities, dependent: :destroy

  validates :username, presence: :true, uniqueness: { case_sensitive: false }
  validate :validate_username

  def login
    @login || self.username || self.email
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_h).where(["lower(username) = :value OR lower(email) = :value", { value: login.downcase }]).first
    elsif conditions.has_key?(:username) || conditions.has_key?(:email)
      where(conditions.to_h).first
    end
  end

  def active_for_authentication?
    super && ! self.discarded?
  end

  def inactive_message
    self.discarded? ? :deleted_account : super
  end

  has_settings do |s|
    s.key :default_units, defaults: {
      temperature: Unit.default_temperature,
      speed: Unit.default_speed,
      velocity: Unit.default_velocity,
      pressure: Unit.default_pressure,
      length: Unit.default_length,
      distance: Unit.default_distance,
      scope_adjustment: Unit.default_scope_adjustment,
      ballistic_coefficient: Unit.default_ballistic_coefficient
    }
    s.key :interface, defaults: {
      sort_by: "created_at",
      sort_direction: "desc",
    }
  end

  def update_settings(settings)
    self.settings(:default_units).temperature = settings[:default_temperature]
    self.settings(:default_units).velocity = settings[:default_speed]
    self.settings(:default_units).velocity = settings[:default_velocity]
    self.settings(:default_units).pressure = settings[:default_pressure]
    self.settings(:default_units).length = settings[:default_length]
    self.settings(:default_units).distance = settings[:default_distance]
    self.settings(:default_units).scope_adjustment = settings[:default_scope_adjustment]
    self.settings(:default_units).ballistic_coefficient = settings[:default_ballistic_coefficient]
    self.settings(:interface).sort_by = settings[:default_sort_by]
    self.settings(:interface).sort_direction = settings[:default_sort_direction]
    self.save
  end

  def self.interface_settings
    {
      sort_by: ["created_at", "updated_at", "name"],
      sort_direction: ["desc", "asc"],
    }
  end

  private

    def validate_username
      if User.where(email: username).exists?
        errors.add(:username, :invalid)
      end
    end
end
