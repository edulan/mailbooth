# MailBooth :mailbox: :eyes:
Simple email service for easy testing.

## Usage
TODO
* Install dependencies (`bundle install`)
* Configure host and port
* Configure redis connection

For start using Mailbooth your first need to create an inbox to deliver the messages to:
```
rake mailbooth:inbox:create
```

Once created you need to setup mail configuration with the provided information:
```ruby
config.action_mailer.delivery_method = :smtp
config.action_mailer.smtp_settings = {
  :user_name => '336256108233828ec',
  :password => 'a4daec85f76a02',
  :address => 'localhost',
  :domain => 'localhost',
  :port => '1025',
  :authentication => :plain
}
```

For starting the application just type:
```
foreman start
```

## Design
The system is composed of 2 services:

### SMTP server
This service acts as a dummy SMTP server. It implements the SMTP protocol and forwards incoming emails to a REST API. The email is parsed and splitted in fields for an easy lookup via API.

### API server
This server stores emails coming from the SMTP server, indexes them and expose a simple interface for querying them.

## Development

### Enable logging
To enable SMTP server logging:
```
```