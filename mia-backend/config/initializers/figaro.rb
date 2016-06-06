Figaro.require_keys(
    'aws_access_key_id',
    'aws_secret_access_key',
    'aws_region',
    'aws_et_pipeline_id',
    'aws_s3_bucket'
)

unless Rails.env.test?
  Figaro.require_keys(
    'aws_et_sns_topic_arn',
    'host'
  )
end

if Rails.env.production?
  Figaro.require_keys(
      'smtp_domain',
      'smtp_address',
      'smtp_port',
      'smtp_username',
      'smtp_password'
  )
end