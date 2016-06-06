video_urls = [
    'https://www.youtube.com/watch?v=xjsI4-hsJCw',
    'https://www.youtube.com/watch?v=nOokGTBs3gs',
    'https://www.youtube.com/watch?v=Y7QQS5V3cnI',
    'https://www.youtube.com/watch?v=FijBkSvN6N8',
    'https://vimeo.com/couchmode/inbox/sort:date/57863017',
    'https://vimeo.com/couchmode/inbox/sort:date/99575154',
    'https://vimeo.com/couchmode/inbox/sort:date/89124343',
    'https://vimeo.com/couchmode/inbox/sort:date/103923180',
    'https://vimeo.com/couchmode/inbox/sort:date/103637782',
    'https://vimeo.com/couchmode/inbox/sort:date/88504479',
    'https://vimeo.com/couchmode/inbox/sort:date/103637782',
    'https://vimeo.com/couchmode/inbox/sort:date/101098490',
    'https://vimeo.com/couchmode/inbox/sort:date/103437078',
    'https://vimeo.com/couchmode/inbox/sort:date/102513133',
    'https://vimeo.com/couchmode/inbox/sort:date/104270416',
    'https://vimeo.com/couchmode/inbox/sort:date/104088954',
    'https://vimeo.com/couchmode/inbox/sort:date/103902152',
    'https://vimeo.com/couchmode/inbox/sort:date/103316694',
    'https://vimeo.com/couchmode/inbox/sort:date/103671108',
    'https://vimeo.com/couchmode/inbox/sort:date/103411714',
    'https://vimeo.com/couchmode/inbox/sort:date/103939722',
    'https://vimeo.com/couchmode/inbox/sort:date/65793134',
    'https://vimeo.com/couchmode/inbox/sort:date/36899035',
    'https://vimeo.com/couchmode/inbox/sort:date/103092939',
    'https://vimeo.com/couchmode/inbox/sort:date/103975643',
    'https://vimeo.com/couchmode/inbox/sort:date/87712104',
    'https://vimeo.com/couchmode/inbox/sort:date/103927232',
    'https://vimeo.com/couchmode/inbox/sort:date/94611333'
]
#
# video_urls.each do |url|
#
#   video = Video.where(:external_url => url).first_or_create({:external_url => url, :published => true, :owner => User.first})
#   if (!video.save)
#     raise "Video with url #{url} is not valid: #{video.errors.full_messages}"
#   else
#     puts "Created video with url #{url}"
#
#     10.times do |i|
#       VideoMotif.create( :motif => Motif.find(rand(Motif.count)+1), :video => video, :description => "General #{i}", :owner => User.first )
#     end
#
#     10.times do |i|
#       timestamp = rand(1000)
#       VideoMotif.create( :motif => Motif.find(rand(Motif.count)+1), :video => video, :description => "Timestamped #{i} @ #{timestamp}", :owner => User.first, :timestamp => timestamp)
#     end
#
#   end
#
# end