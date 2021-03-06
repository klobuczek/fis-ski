module FisModel
  attr_accessor :rule

  def compare c, *spec
    spec.each do |attr, direction|
      comparison = direction * (nvl(attr) <=> c.nvl(attr))
      return comparison unless comparison == 0
    end
    0
  end

  def nvl symbol
    send(symbol) || 99999
  end

  def <=> c
    compare c, [:cup_points, -1], [:race_points, 1]
  end
end