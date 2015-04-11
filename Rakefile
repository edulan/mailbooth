namespace :mailbooth do
  desc 'Flush all data (inboxes, messages, ect.)'
  task :flush_all do
    require 'redic'

    redis = Redic.new

    redis.queue 'FLUSHDB'
    redis.queue 'FLUSHALL'
    redis.commit
  end

  desc 'Show inboxes'
  task :show do
    require './models/inbox'
    require './models/message'

    Mailbooth::Models::Inbox.all.each do |i|
      puts "INBOX for #{i.name}"

      i.messages.each do |m|
        puts ">>> MAIL #{m.source}"
      end
    end
  end
end
