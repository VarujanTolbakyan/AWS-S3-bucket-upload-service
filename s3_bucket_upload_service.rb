class S3BucketUploadService
  attr_reader :file_path, :object_key

  def initialize(file_extname, file_path, prefix)
    filename = "#{SecureRandom.uuid}#{file_extname}"
    @object_key = Pathname.new(prefix.to_s).join(filename).to_s
    @file_path = file_path
  end

  def upload
    bucket_name = Rails.application.credentials.s3_storage_bucket!

    creds = Aws::Credentials.new(Rails.application.credentials.s3_access_key_id!,
                                 Rails.application.credentials.s3_secret_key!)
    s3 = Aws::S3::Resource.new(region: Rails.application.credentials.s3_region!, credentials: creds)

    object = s3.bucket(bucket_name).object(object_key)
    object.upload_file(file_path)

    "https://#{Rails.application.credentials.s3_storage_bucket_domain!}/#{object_key}"
  end
end

# Rails.application.credentials.s3_storage_bucket!         your S3 bucket name example: development-test-storage
# Rails.application.credentials.s3_access_key_id!          your AWS access key
# Rails.application.credentials.s3_secret_key!             your AWS secret key
# Rails.application.credentials.s3_region!                 your S3 bucket region example: eu-central-1
# Rails.application.credentials.s3_storage_bucket_domain!  your S3 bucket domain example: development-test-storage.s3.eu-central-1.amazonaws.com
  
# in your Gemfile add   gem 'aws-sdk-s3'
