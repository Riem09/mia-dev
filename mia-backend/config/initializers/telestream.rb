TelestreamCloud.configure do
  access_key Figaro.env.telestream_access_key
  secret_key Figaro.env.telestream_secret_key
  api_host  (Figaro.env.telestream_api_host || "api.cloud.telestream.net")
  factory_id Figaro.env.telestream_factory_id
end
