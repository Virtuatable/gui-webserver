# frozen_string_literal: true

require 'aws-sdk-s3'

s3 = Aws::S3::Resource.new({
                             region: 'fr-par',
                             endpoint: ENV['BS_ENDPOINT'].strip,
                             access_key_id: ENV['BS_ACCESS_KEY'].strip,
                             secret_access_key: ENV['BS_SECRET_KEY'].strip
                           })

bucket = s3.bucket('virtuatable-frontend')

object = bucket.object('auth-gui/current') # 'auth-gui/1650897348')

version = object.get.body.read.to_s.strip

puts "[COPYING auth-gui/#{version}]"
bucket.objects(prefix: "auth-gui/#{version}").each do |obj|
  key = obj.key.clone
  key["auth-gui/#{version}"] = 'public'
  File.write(key, obj.get.body.read.to_s)
  puts "#{obj.key} -> #{key}"
end
