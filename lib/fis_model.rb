module FisModel
  def compare c, *spec
    spec.each do |attr, direction|
      comparison = direction * (send(attr) <=> c.send(attr))
      return comparison unless comparison == 0
    end
    0
  end
  
  def <=> c
    compare c, [:cup_points, -1], [:fis_points, 1]
  end
end