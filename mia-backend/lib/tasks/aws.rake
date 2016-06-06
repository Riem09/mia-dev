require 'pp'

namespace :aws do

  namespace :et do

    desc 'List the Elastic Transcoding jobs'
    task :list_remote => :environment do
      transcoder_client = AWS::ElasticTranscoder::Client.new(region: Figaro.env.aws_region)
      VideoUpload.all.each do |vu|
        response = transcoder_client.read_job( { id: vu.job_id } )
        puts response.to_yaml
      end
    end

    desc 'Update job statuses from AWS Elastic Transcoder'
    task :update => :environment do
      VideoUpload.update_from_et
    end

  end
end