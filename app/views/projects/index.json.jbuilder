json.array!(@projects) do |project|
  json.extract! project, :id, :title,, :url,, :description, :ord, :null, :default, :display, :null, :false,, :default, :true
  json.url project_url(project, format: :json)
end
