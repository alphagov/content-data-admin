RSpec.describe DateRange do
  around do |example|
    Timecop.freeze Date.new(2018, 12, 25) do
      example.run
    end
  end

  describe 'for past 30 days' do
    let(:time_period) { 'past-30-days' }

    describe 'relative to yesterday' do
      subject { DateRange.new(time_period) }

      it { is_expected.to have_attributes(to: '2018-12-24') }
      it { is_expected.to have_attributes(from: '2018-11-24') }
      it { is_expected.to have_attributes(time_period: 'past-30-days') }
    end

    describe 'relative to specified date' do
      subject { DateRange.new(time_period, specified_date) }
      let(:specified_date) { Date.new(2018, 6, 25) }

      it { is_expected.to have_attributes(to: '2018-06-25') }
      it { is_expected.to have_attributes(from: '2018-05-26') }
      it { is_expected.to have_attributes(time_period: 'past-30-days') }
    end

    describe '#previous' do
      subject { DateRange.new(time_period).previous }

      it { is_expected.to be_an_instance_of(DateRange) }
      it { is_expected.to have_attributes(to: '2018-11-24') }
      it { is_expected.to have_attributes(from: '2018-10-25') }
      it { is_expected.to have_attributes(time_period: 'past-30-days') }
    end
  end

  describe 'for last month' do
    let(:time_period) { 'last-month' }

    describe 'relative to yesterday' do
      subject { DateRange.new(time_period) }

      it { is_expected.to have_attributes(to: '2018-11-30') }
      it { is_expected.to have_attributes(from: '2018-11-01') }
      it { is_expected.to have_attributes(time_period: 'last-month') }
    end

    describe 'relative to specified date' do
      subject { DateRange.new(time_period, specified_date) }
      let(:specified_date) { Date.new(2018, 6, 25) }

      it { is_expected.to have_attributes(to: '2018-05-31') }
      it { is_expected.to have_attributes(from: '2018-05-01') }
      it { is_expected.to have_attributes(time_period: 'last-month') }
    end

    describe '#previous' do
      subject { DateRange.new(time_period).previous }

      it { is_expected.to be_an_instance_of(DateRange) }
      it { is_expected.to have_attributes(to: '2018-10-31') }
      it { is_expected.to have_attributes(from: '2018-10-01') }
      it { is_expected.to have_attributes(time_period: 'last-month') }
    end
  end

  describe 'for past 3 months' do
    let(:time_period) { 'past-3-months' }

    describe 'relative to yesterday' do
      subject { DateRange.new(time_period) }

      it { is_expected.to have_attributes(to: '2018-12-24') }
      it { is_expected.to have_attributes(from: '2018-09-24') }
      it { is_expected.to have_attributes(time_period: 'past-3-months') }
    end

    describe 'relative to specified date' do
      subject { DateRange.new(time_period, specified_date) }
      let(:specified_date) { Date.new(2018, 6, 25) }

      it { is_expected.to have_attributes(to: '2018-06-25') }
      it { is_expected.to have_attributes(from: '2018-03-25') }
      it { is_expected.to have_attributes(time_period: 'past-3-months') }
    end

    describe '#previous' do
      subject { DateRange.new(time_period).previous }

      it { is_expected.to be_an_instance_of(DateRange) }
      it { is_expected.to have_attributes(to: '2018-09-24') }
      it { is_expected.to have_attributes(from: '2018-06-24') }
      it { is_expected.to have_attributes(time_period: 'past-3-months') }
    end
  end

  describe 'for past 6 months' do
    let(:time_period) { 'past-6-months' }

    describe 'relative to yesterday' do
      subject { DateRange.new(time_period) }

      it { is_expected.to have_attributes(to: '2018-12-24') }
      it { is_expected.to have_attributes(from: '2018-06-24') }
      it { is_expected.to have_attributes(time_period: 'past-6-months') }
    end

    describe 'relative to specified date' do
      subject { DateRange.new(time_period, specified_date) }
      let(:specified_date) { Date.new(2018, 6, 25) }

      it { is_expected.to have_attributes(to: '2018-06-25') }
      it { is_expected.to have_attributes(from: '2017-12-25') }
      it { is_expected.to have_attributes(time_period: 'past-6-months') }
    end

    describe '#previous' do
      subject { DateRange.new(time_period).previous }

      it { is_expected.to be_an_instance_of(DateRange) }
      it { is_expected.to have_attributes(to: '2018-06-24') }
      it { is_expected.to have_attributes(from: '2017-12-24') }
      it { is_expected.to have_attributes(time_period: 'past-6-months') }
    end
  end

  describe 'for past year' do
    let(:time_period) { 'past-year' }

    describe 'relative to yesterday' do
      subject { DateRange.new(time_period) }

      it { is_expected.to have_attributes(to: '2018-12-24') }
      it { is_expected.to have_attributes(from: '2017-12-24') }
      it { is_expected.to have_attributes(time_period: 'past-year') }
    end

    describe 'relative to specified date' do
      subject { DateRange.new(time_period, specified_date) }
      let(:specified_date) { Date.new(2018, 6, 25) }

      it { is_expected.to have_attributes(to: '2018-06-25') }
      it { is_expected.to have_attributes(from: '2017-06-25') }
      it { is_expected.to have_attributes(time_period: 'past-year') }
    end

    describe '#previous' do
      subject { DateRange.new(time_period).previous }

      it { is_expected.to be_an_instance_of(DateRange) }
      it { is_expected.to have_attributes(to: '2017-12-24') }
      it { is_expected.to have_attributes(from: '2016-12-24') }
      it { is_expected.to have_attributes(time_period: 'past-year') }
    end
  end
end
