RSpec.describe DateRange do
  before do
    Timecop.freeze(Time.zone.parse('2018-12-25'))
  end

  after do
    Timecop.return
  end

  describe '.to' do
    context 'when relative to today`s date' do
      context 'and the time period is last-30-days' do
        it 'returns today`s date' do
          expect(DateRange.new('last-30-days').to).to eq('2018-12-25')
        end
      end
      context 'and the time period is last-3-months' do
        it 'returns today`s date' do
          expect(DateRange.new('last-3-months').to).to eq('2018-12-25')
        end
      end
      context 'and the time period is last-6-months' do
        it 'returns today`s date' do
          expect(DateRange.new('last-6-months').to).to eq('2018-12-25')
        end
      end
      context 'and the time period is last-year' do
        it 'returns today`s date' do
          expect(DateRange.new('last-year').to).to eq('2018-12-25')
        end
      end
      context 'and the time period is last-2-years' do
        it 'returns today`s date' do
          expect(DateRange.new('last-2-years').to).to eq('2018-12-25')
        end
      end
      context 'and the time period is last-month' do
        it 'returns today`s date' do
          expect(DateRange.new('last-month').to).to eq('2018-11-30')
        end
      end
    end
    context 'when relative to specified date' do
      let(:specified_date) { Date.parse('2018-06-15') }
      context 'and the time period is last-30-days' do
        it 'returns specified date' do
          expect(DateRange.new('last-30-days', specified_date).to).to eq('2018-06-15')
        end
      end
      context 'and the time period is last-3-months' do
        it 'returns specified date' do
          expect(DateRange.new('llast-3-months', specified_date).to).to eq('2018-06-15')
        end
      end
      context 'and the time period is last-6-months' do
        it 'returns specified date' do
          expect(DateRange.new('last-6-months', specified_date).to).to eq('2018-06-15')
        end
      end
      context 'and the time period is last-year' do
        it 'returns specified date' do
          expect(DateRange.new('last-year', specified_date).to).to eq('2018-06-15')
        end
      end
      context 'and the time period is last-2-years' do
        it 'returns specified date' do
          expect(DateRange.new('last-2-years', specified_date).to).to eq('2018-06-15')
        end
      end
      context 'and the time period is last-month' do
        it 'returns date of last day in previous month from specified date' do
          expect(DateRange.new('last-month', specified_date).to).to eq('2018-05-31')
        end
      end
    end
  end

  describe '.from' do
    context 'relative to today`s date' do
      context 'when time period is last-30-days' do
        it 'returns date of 30 days ago' do
          expect(DateRange.new('last-30-days').from).to eq('2018-11-25')
        end
      end
      context 'when time period is last-3-months' do
        it 'returns date of 3 months ago' do
          expect(DateRange.new('last-3-months').from).to eq('2018-09-25')
        end
      end
      context 'when time period is last-6-months' do
        it 'returns date of 6 months ago' do
          expect(DateRange.new('last-6-months').from).to eq('2018-06-25')
        end
      end
      context 'when time period is last-year' do
        it 'returns date of 1 year ago' do
          expect(DateRange.new('last-year').from).to eq('2017-12-25')
        end
      end
      context 'when time period is last-2-years' do
        it 'returns date of 2 years ago' do
          expect(DateRange.new('last-2-years').from).to eq('2016-12-25')
        end
      end
      context 'when time period is last-month' do
        it 'returns date of first day of previous month' do
          expect(DateRange.new('last-month').from).to eq('2018-11-01')
        end
      end
    end
    context 'when relative to specified date' do
      let(:specified_date) { Date.parse('2018-06-15') }
      context 'and the time period is last-30-days' do
        it 'returns specified date' do
          expect(DateRange.new('last-30-days', specified_date).from).to eq('2018-05-16')
        end
      end
      context 'and the time period is last-3-months' do
        it 'returns specified date' do
          expect(DateRange.new('last-3-months', specified_date).from).to eq('2018-03-15')
        end
      end
      context 'and the time period is last-6-months' do
        it 'returns specified date' do
          expect(DateRange.new('last-6-months', specified_date).from).to eq('2017-12-15')
        end
      end
      context 'and the time period is last-year' do
        it 'returns specified date' do
          expect(DateRange.new('last-year', specified_date).from).to eq('2017-06-15')
        end
      end
      context 'and the time period is last-2-years' do
        it 'returns date of last day in previous month from specified date' do
          expect(DateRange.new('last-2-years', specified_date).from).to eq('2016-06-15')
        end
      end
      context 'and the time period is last-month' do
        it 'returns date of last day in previous month from specified date' do
          expect(DateRange.new('last-month', specified_date).from).to eq('2018-05-01')
        end
      end
    end
  end
end
