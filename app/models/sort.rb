class Sort
  include ActiveModel::Validations

  attr_reader :key, :direction

  validates :key, presence: true
  validates :direction, inclusion: { in: %w(asc desc) }

  def initialize(key, direction)
    @key = key
    @direction = direction
  end

  def self.parse(sort_str)
    split_str = sort_str.split(':')

    key = split_str[0] || ''
    direction = split_str[1] || ''

    new(key, direction)
  end

  def to_s
    "#{@key}:#{@direction}"
  end

  def reverse!
    @direction = @direction == 'asc' ? 'desc' : 'asc'
  end
end
