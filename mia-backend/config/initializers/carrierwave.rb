require 'carrierwave/orm/activerecord'

CarrierWave.configure do |config|
  if Rails.env.production?
    config.storage :fog
  else
    config.storage :file
  end
  if Rails.env.test?
    Fog.mock!
  end
  config.fog_credentials = {
      provider: 'AWS',
      region: Figaro.env.aws_region,
      aws_access_key_id: Figaro.env.aws_access_key_id,
      aws_secret_access_key: Figaro.env.aws_secret_access_key
  }
  config.fog_public = true
  config.fog_directory = Figaro.env.aws_s3_bucket
  config.fog_authenticated_url_expiration = 60 * 60 * 24 * 365
  config.cache_dir = "#{Rails.root}/tmp/uploads"

  config.max_file_size = 300.megabytes

end
