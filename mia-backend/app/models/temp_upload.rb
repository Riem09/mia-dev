class TempUpload < ActiveRecord::Base
  mount_uploader :upload, TempUploader
end
