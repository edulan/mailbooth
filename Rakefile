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
    require './models'

    Mailbooth::Models::Inbox.all.each do |i|
      puts ">> INBOX ##{i.id} for #{i.name}"

      i.messages.each do |m|
        puts ">>> MAIL\n#{m.data}"
      end
    end
  end
end

namespace :grape do
  desc 'Print compiled grape routes'
  task :routes do
    require './api'

    Mailbooth::API.routes.each do |route|
      puts route
    end
  end
end
