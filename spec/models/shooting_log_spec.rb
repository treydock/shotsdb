require 'rails_helper'

RSpec.describe ShootingLog, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:shooting_location) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of :date }
    it { is_expected.to validate_presence_of :time }
  end

  describe 'temperature_unit' do
    it 'should pull value from database' do
      user = create(:user)
      shooting_log = create(:shooting_log, user: user, temperature_unit: 'C')
      user.settings(:default_units).temperature = 'F'
      user.save!
      expect(shooting_log.temperature_unit).to eq('C')
    end
    it 'should pull value from user default' do
      user = create(:user)
      shooting_log = create(:shooting_log, user: user, temperature_unit: '')
      user.settings(:default_units).temperature = 'F'
      user.save!
      expect(shooting_log.temperature_unit).to eq('F')
    end
  end

  describe 'pressure_unit' do
    it 'should pull value from database' do
      user = create(:user)
      shooting_log = create(:shooting_log, user: user, pressure_unit: 'atm')
      user.settings(:default_units).pressure = 'inhg'
      user.save!
      expect(shooting_log.pressure_unit).to eq('atm')
    end
    it 'should pull value from user default' do
      user = create(:user)
      shooting_log = create(:shooting_log, user: user, pressure_unit: '')
      user.settings(:default_units).pressure = 'inhg'
      user.save!
      expect(shooting_log.pressure_unit).to eq('inhg')
    end
  end

  describe 'wind_speed_unit' do
    it 'should pull value from database' do
      user = create(:user)
      shooting_log = create(:shooting_log, user: user, wind_speed_unit: 'kph')
      user.settings(:default_units).speed = 'mph'
      user.save!
      expect(shooting_log.wind_speed_unit).to eq('kph')
    end
    it 'should pull value from user default' do
      user = create(:user)
      shooting_log = create(:shooting_log, user: user, wind_speed_unit: '')
      user.settings(:default_units).speed = 'mph'
      user.save!
      expect(shooting_log.wind_speed_unit).to eq('mph')
    end
  end
end
