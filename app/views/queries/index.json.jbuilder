json.array!(@queries) do |query|
  json.extract! query, :id, :origins, :destinations, :origin_dates, :destination_dates
  json.url query_url(query, format: :json)
end
