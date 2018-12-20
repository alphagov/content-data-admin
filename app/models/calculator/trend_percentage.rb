class Calculator::TrendPercentage
  attr_reader :current_value, :previous_value

  def initialize(current_value, previous_value)
    @current_value = current_value
    @previous_value = previous_value
  end

  def run
    return 0 if previous_value <= 0

    trend
  end

  def trend
    ((current_value.to_f / previous_value.to_f) - 1) * 100
  end
end
