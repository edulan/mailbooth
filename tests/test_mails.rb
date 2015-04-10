require './models/inbox'
require './models/mail'

Mailbooth::Models::Inbox.all.each do |i|
  puts "INBOX for #{i.name}"

  i.mails.each do |m|
    puts ">>> MAIL #{m.source}"
  end
end
