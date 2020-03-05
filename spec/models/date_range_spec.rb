RSpec.describe DateRange do
  around do |example|
    Timecop.freeze Date.new(2018, 12, 25) do
      example.run
    end
  end

  describe "for past 30 days" do
    let(:time_period) { "past-30-days" }

    describe "relative to yesterday" do
      subject { DateRange.new(time_period) }

      it { is_expected.to have_attributes(to: Date.new(2018, 12, 24)) }
      it { is_expected.to have_attributes(from: Date.new(2018, 11, 25)) }
      it { is_expected.to have_attributes(time_period: "past-30-days") }
    end

    describe "relative to specified date" do
      subject { DateRange.new(time_period, specified_date) }
      let(:specified_date) { Date.new(2018, 6, 25) }

      it { is_expected.to have_attributes(to: Date.new(2018, 6, 25)) }
      it { is_expected.to have_attributes(from: Date.new(2018, 5, 27)) }
      it { is_expected.to have_attributes(time_period: "past-30-days") }
    end

    describe "#previous" do
      subject { DateRange.new(time_period).previous }

      it { is_expected.to be_an_instance_of(DateRange) }
      it { is_expected.to have_attributes(to: Date.new(2018, 11, 24)) }
      it { is_expected.to have_attributes(from: Date.new(2018, 10, 26)) }
      it { is_expected.to have_attributes(time_period: "past-30-days") }
    end
  end

  describe "for last month" do
    let(:time_period) { "last-month" }

    describe "relative to yesterday" do
      subject { DateRange.new(time_period) }

      it { is_expected.to have_attributes(to: Date.new(2018, 11, 30)) }
      it { is_expected.to have_attributes(from: Date.new(2018, 11, 1)) }
      it { is_expected.to have_attributes(time_period: "last-month") }
    end

    describe "relative to specified date" do
      subject { DateRange.new(time_period, specified_date) }
      let(:specified_date) { Date.new(2018, 6, 25) }

      it { is_expected.to have_attributes(to: Date.new(2018, 5, 31)) }
      it { is_expected.to have_attributes(from: Date.new(2018, 5, 1)) }
      it { is_expected.to have_attributes(time_period: "last-month") }
    end

    describe "#previous" do
      subject { DateRange.new(time_period).previous }

      it { is_expected.to be_an_instance_of(DateRange) }
      it { is_expected.to have_attributes(to: Date.new(2018, 10, 31)) }
      it { is_expected.to have_attributes(from: Date.new(2018, 10, 1)) }
      it { is_expected.to have_attributes(time_period: "last-month") }
    end
  end

  describe "for past 3 months" do
    let(:time_period) { "past-3-months" }

    describe "relative to yesterday" do
      subject { DateRange.new(time_period) }

      it { is_expected.to have_attributes(to: Date.new(2018, 12, 24)) }
      it { is_expected.to have_attributes(from: Date.new(2018, 9, 25)) }
      it { is_expected.to have_attributes(time_period: "past-3-months") }
    end

    describe "relative to specified date" do
      subject { DateRange.new(time_period, specified_date) }
      let(:specified_date) { Date.new(2018, 6, 25) }

      it { is_expected.to have_attributes(to: Date.new(2018, 6, 25)) }
      it { is_expected.to have_attributes(from: Date.new(2018, 3, 26)) }
      it { is_expected.to have_attributes(time_period: "past-3-months") }
    end

    describe "#previous" do
      subject { DateRange.new(time_period).previous }

      it { is_expected.to be_an_instance_of(DateRange) }
      it { is_expected.to have_attributes(to: Date.new(2018, 9, 24)) }
      it { is_expected.to have_attributes(from: Date.new(2018, 6, 25)) }
      it { is_expected.to have_attributes(time_period: "past-3-months") }
    end
  end

  describe "for past 6 months" do
    let(:time_period) { "past-6-months" }

    describe "relative to yesterday" do
      subject { DateRange.new(time_period) }

      it { is_expected.to have_attributes(to: Date.new(2018, 12, 24)) }
      it { is_expected.to have_attributes(from: Date.new(2018, 6, 25)) }
      it { is_expected.to have_attributes(time_period: "past-6-months") }
    end

    describe "relative to specified date" do
      subject { DateRange.new(time_period, specified_date) }
      let(:specified_date) { Date.new(2018, 6, 25) }

      it { is_expected.to have_attributes(to: Date.new(2018, 6, 25)) }
      it { is_expected.to have_attributes(from: Date.new(2017, 12, 26)) }
      it { is_expected.to have_attributes(time_period: "past-6-months") }
    end

    describe "#previous" do
      subject { DateRange.new(time_period).previous }

      it { is_expected.to be_an_instance_of(DateRange) }
      it { is_expected.to have_attributes(to: Date.new(2018, 6, 24)) }
      it { is_expected.to have_attributes(from: Date.new(2017, 12, 25)) }
      it { is_expected.to have_attributes(time_period: "past-6-months") }
    end
  end

  describe "for past year" do
    let(:time_period) { "past-year" }

    describe "relative to yesterday" do
      subject { DateRange.new(time_period) }

      it { is_expected.to have_attributes(to: Date.new(2018, 12, 24)) }
      it { is_expected.to have_attributes(from: Date.new(2017, 12, 25)) }
      it { is_expected.to have_attributes(time_period: "past-year") }
    end

    describe "relative to specified date" do
      subject { DateRange.new(time_period, specified_date) }
      let(:specified_date) { Date.new(2018, 6, 25) }

      it { is_expected.to have_attributes(to: Date.new(2018, 6, 25)) }
      it { is_expected.to have_attributes(from: Date.new(2017, 6, 26)) }
      it { is_expected.to have_attributes(time_period: "past-year") }
    end

    describe "#previous" do
      subject { DateRange.new(time_period).previous }

      it { is_expected.to be_an_instance_of(DateRange) }
      it { is_expected.to have_attributes(to: Date.new(2017, 12, 24)) }
      it { is_expected.to have_attributes(from: Date.new(2016, 12, 25)) }
      it { is_expected.to have_attributes(time_period: "past-year") }
    end
  end

  describe "for past 2 year" do
    let(:time_period) { "past-2-years" }

    describe "relative to yesterday" do
      subject { DateRange.new(time_period) }

      it { is_expected.to have_attributes(to: Date.new(2018, 12, 24)) }
      it { is_expected.to have_attributes(from: Date.new(2016, 12, 25)) }
      it { is_expected.to have_attributes(time_period: "past-2-years") }
    end

    describe "relative to specified date" do
      subject { DateRange.new(time_period, specified_date) }
      let(:specified_date) { Date.new(2018, 6, 25) }

      it { is_expected.to have_attributes(to: Date.new(2018, 6, 25)) }
      it { is_expected.to have_attributes(from: Date.new(2016, 6, 26)) }
      it { is_expected.to have_attributes(time_period: "past-2-years") }
    end

    describe "#previous" do
      subject { DateRange.new(time_period).previous }

      it { is_expected.to be_an_instance_of(DateRange) }
      it { is_expected.to have_attributes(to: Date.new(2016, 12, 24)) }
      it { is_expected.to have_attributes(from: Date.new(2014, 12, 25)) }
      it { is_expected.to have_attributes(time_period: "past-2-years") }
    end
  end

  describe "for a specific month and year" do
    let(:time_period) { "november-2019" }

    describe "relative to the specified month and year" do
      subject { DateRange.new(time_period) }

      it { is_expected.to have_attributes(to: Date.new(2019, 11, 30)) }
      it { is_expected.to have_attributes(from: Date.new(2019, 11, 1)) }
      it { is_expected.to have_attributes(time_period: "november-2019") }
    end

    describe "#previous" do
      subject { DateRange.new(time_period).previous }

      it { is_expected.to be_an_instance_of(DateRange) }
      it { is_expected.to have_attributes(to: Date.new(2019, 10, 31)) }
      it { is_expected.to have_attributes(from: Date.new(2019, 10, 1)) }
      it { is_expected.to have_attributes(time_period: "october-2019") }
    end

    describe "when an invalid month is specified" do
      subject { DateRange.new("september-1885") }

      it { is_expected.to have_attributes(to: Date.new(2018, 12, 24)) }
      it { is_expected.to have_attributes(from: Date.new(2018, 11, 25)) }
      it { is_expected.to have_attributes(time_period: "past-30-days") }
    end
  end
end
