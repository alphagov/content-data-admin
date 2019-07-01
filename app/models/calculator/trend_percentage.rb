class Calculator::TrendPercentage
  def self.calculate(*args)
    new(*args).calculate
  end

  def initialize(current, previous)
    @current = current
    @previous = previous
  end

  def calculate
    if previous.nil? || current.nil?
      nil
    elsif previous <= 0
      0
    else
      trend
    end
  end

private

  attr_reader :current, :previous

  def trend
    ((current / previous.to_f) - 1) * 100
  end
end
