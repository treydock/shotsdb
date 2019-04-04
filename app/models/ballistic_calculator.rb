# REF: https://www.ar15.com/forums/armory/Bullet_Drop_Formula/42-351773/#i3198632
class BallisticCalculator
  include ActiveModel::Model

  attr_accessor :ballistic_coefficient
  attr_accessor :velocity
  attr_accessor :range
  attr_accessor :height_of_sight
  attr_accessor :zero_range

  attr_accessor :caliber_id
  attr_accessor :load_id
  attr_accessor :gun_id

  validates :ballistic_coefficient, numericality: true
  validates :velocity, numericality: true
  validates :range, numericality: true
  validates :height_of_sight, numericality: true
  validates :zero_range, numericality: true

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  [
    :ballistic_coefficient,
    :velocity,
    :range,
    :height_of_sight,
    :zero_range,
  ].each do |a|
    define_method(a) do
      value = instance_variable_get("@#{a}")
      if value.present?
        if value.to_f.to_s == value.to_s
          value = value.to_f
        end
      end
      value
    end
  end

  # remaining velocity, fps
  def RV
    ((Math.sqrt(velocity)) - 0.00863 * (range / ballistic_coefficient))**2
  end

  # dummy variable
  def K
    2.878 / (ballistic_coefficient * Math.sqrt(velocity))
  end

  # time of flight, seconds
  def TF
    (3 * range) / (velocity * (1 - (0.003 * range * self.K)))
  end

  # dummy variable
  def F
    193 * (1 - ((0.37 * (velocity - self.RV)) / velocity))
  end

  # total drop from line of departure, inches
  def DR
    self.F * self.TF**2
  end

  # maximum height of trajectory above sight line, inches
  def MH
    (48.6 * self.TF**2) - (0.4 * height_of_sight)
  end

  # elevation required, moa
  def EL(r)
    orig_range = @range
    @range = r
    value = (100 * (self.DR + height_of_sight)) / range
    @range = orig_range
    value
  end

  # bullet path above or below line of sight, inches
  def BP
    el0 = self.EL(zero_range)
    el1 = self.EL(range)
    ((el0 - el1) * range) / 100
  end

  # bullet path above or below line of sight, moa
  def BP_moa
    self.BP / (range / 100)
  end

  # wind deflection, inches
  def WD(ws, wa = 180)
    wind_speed = ws.to_f
    wind_angle = wa.to_f
    #if wind_angle > 180.0
    #  wind_angle = 360.0 - wind_angle
    #end
    (wind_speed / 10) * (wind_angle) * (self.TF - ((3 * range.to_f) / velocity.to_f))
  end

  # wind deflection, moa
  def WD_moa(wind_speed, wind_angle = 180)
    self.WD(wind_speed, wind_angle) / (range / 100)
  end

  # USMC method
  # http://www.millettsights.com/resources/shooting-tips/mathematics-for-precision-shooters/
  def wind_drift_moa(wind_speed, single_value = false)
    value = ((range / 100) * wind_speed.to_f) / 15
    return value if single_value
    [value.round(1), self.WD_moa(wind_speed).round(1)]
  end

  def wind_drift(wind_speed)
    moa = self.wind_drift_moa(wind_speed, true)
    value = moa * (range / 100)
    [value.round(1), self.WD(wind_speed).round(1)]
  end
end
