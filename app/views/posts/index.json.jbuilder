json.array!(@posts) do |post|
  json.extract! post, :id, :body, :published
  json.url post_url(post, format: :json)
end
