class TempUploader < CarrierWave::Uploader::Base
  include CarrierWaveDirect::Uploader
  def store_dir
    "#{super}/tmp"
  end
end