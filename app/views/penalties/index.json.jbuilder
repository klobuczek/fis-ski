json.array!(@penalties) do |penalty|
  json.extract! penalty, :id, :category, :min, :max
  json.url penalty_url(penalty, format: :json)
end
