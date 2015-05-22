namespace :mailbooth do
  namespace :messages do
    desc 'Flush all messages data'
    task :flush_all do
      require 'redic'

      redis = Redic.new

      redis.queue 'FLUSHDB'
      redis.queue 'FLUSHALL'
      redis.commit
    end

    desc 'Show all messages'
    task :show_all do
      require './app/models/message'

      Mailbooth::Models::Message.all.each do |m|
        puts ">> MAIL ##{m.id}"
        puts ">> #{m.to}"
        puts ">> #{m.subject}"
      end
    end
  end
end

namespace :grape do
  desc 'Print compiled grape routes'
  task :routes do
    require './app/api'

    Mailbooth::App.routes.each do |route|
      puts route
    end
  end
end
