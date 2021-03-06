# frozen_string_literal: true

class ShootingGroup < ApplicationRecord
  include UserOwned
  include HasCaliber
  include HasLoad
  include HasWindSpeed

  belongs_to :shooting_log
  delegate :bullet, to: :load

  validates :distance, presence: true, numericality: { only_integer: true }
  validates :number, presence: true, numericality: { only_integer: true }, uniqueness: { scope: [:shooting_log, :load, :user, :distance] }
  validates :elevation_adjustment_direction, absence: true, unless: Proc.new { |a| a.elevation_adjustment.present? }
  validates :windage_adjustment_direction, absence: true, unless: Proc.new { |a| a.windage_adjustment.present? }

  scoped_search on: [:distance], complete_value: true
  scoped_search relation: :shooting_log, on: :date, complete_value: true, rename: :date

  scope :kept, -> { undiscarded.joins(:load, :caliber, :shooting_log).merge(Load.kept).merge(Caliber.kept).merge(ShootingLog.kept) }

  def name
    "#{shooting_log.date} - ##{number} (#{distance} #{distance_unit})"
  end

  def name_full
    name
  end

  def distance_unit
    self[:distance_unit].present? ? self[:distance_unit] : user.settings(:default_units).distance
  end

  def elevation_adjustment_unit
    self[:elevation_adjustment_unit].present? ? self[:elevation_adjustment_unit] : user.settings(:default_units).scope_adjustment
  end

  def windage_adjustment_unit
    self[:windage_adjustment_unit].present? ? self[:windage_adjustment_unit] : user.settings(:default_units).scope_adjustment
  end

  def group_size_unit
    self[:group_size_unit].present? ? self[:group_size_unit] : user.settings(:default_units).length
  end

  def distance_full
    return distance unless distance.present?
    "#{distance} #{distance_unit}"
  end

  def elevation_adjustment_full
    return elevation_adjustment unless elevation_adjustment.present?
    "#{elevation_adjustment} #{elevation_adjustment_unit} #{elevation_adjustment_direction}"
  end

  def windage_adjustment_full
    return windage_adjustment unless windage_adjustment.present?
    "#{windage_adjustment} #{windage_adjustment_unit} #{windage_adjustment_direction}"
  end

  def group_size_full
    return group_size unless group_size.present?
    "#{group_size} #{group_size_unit}"
  end

  def self.next_number(scope, shooting_log = nil, load = nil, distance = nil)
    if ! shooting_log.present? && ! load.present? && ! distance.present?
      return 1
    end
    if shooting_log.present?
      scope = scope.where(shooting_log_id: shooting_log)
    end
    if load.present?
      scope = scope.where(load_id: load)
    end
    if distance.present?
      scope = scope.where(distance: distance)
    end
    numbers = scope.pluck(:number)
    highest_number = numbers.sort.last
    return 1 unless highest_number.present?
    highest_number + 1
  end

  def clone_record
    new_shooting_group = self.dup
    scope = self.class.by_user(user)
    new_shooting_group.number = self.class.next_number(scope, shooting_log.id, load.id, distance)
    new_shooting_group.group_size = nil
    new_shooting_group
  end
end
