class Calculator::TrendPercentage
  def self.calculate(*args)
    new(*args).calculate
  end

  def initialize(current, previous)
    @current = current
    @previous = previous
  end

  def calculate
    return 0 if previous <= 0

    trend
  end

private

  attr_reader :current, :previous

  def trend
    ((current.to_f / previous.to_f) - 1) * 100
  end
end
