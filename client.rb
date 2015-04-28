# encoding: utf-8

#
# WARNING: Do not edit by hand, this file was generated by Heroics:
#
#   https://github.com/interagent/heroics
#

require 'heroics'
require 'uri'

module MailboothAPI
  # Get a Client configured to use HTTP Basic authentication.
  #
  # @param api_key [String] The API key to use when connecting.
  # @param options [Hash<Symbol,String>] Optionally, custom settings
  #   to use with the client.  Allowed options are `default_headers`,
  #   `cache`, `user` and `url`.
  # @return [Client] A client configured to use the API with HTTP Basic
  #   authentication.
  def self.connect(api_key, options=nil)
    options = custom_options(options)
    uri = URI.parse(options[:url])
    uri.user = URI.encode_www_form_component options.fetch(:user, 'user')
    uri.password = api_key
    client = Heroics.client_from_schema(SCHEMA, uri.to_s, options)
    Client.new(client)
  end

  # Get a Client configured to use OAuth authentication.
  #
  # @param oauth_token [String] The OAuth token to use with the API.
  # @param options [Hash<Symbol,String>] Optionally, custom settings
  #   to use with the client.  Allowed options are `default_headers`,
  #   `cache` and `url`.
  # @return [Client] A client configured to use the API with OAuth
  #   authentication.
  def self.connect_oauth(oauth_token, options=nil)
    options = custom_options(options)
    url = options[:url]
    client = Heroics.oauth_client_from_schema(oauth_token, SCHEMA, url, options)
    Client.new(client)
  end

  # Get a Client configured to use Token authentication.
  #
  # @param token [String] The token to use with the API.
  # @param options [Hash<Symbol,String>] Optionally, custom settings
  #   to use with the client.  Allowed options are `default_headers`,
  #   `cache` and `url`.
  # @return [Client] A client configured to use the API with OAuth
  #   authentication.
  def self.connect_token(token, options=nil)
    options = custom_options(options)
    url = options[:url]
    client = Heroics.token_client_from_schema(token, SCHEMA, url, options)
    Client.new(client)
  end

  # Get customized options.
  def self.custom_options(options)
    return default_options if options.nil?

    final_options = default_options
    if options[:default_headers]
      final_options[:default_headers].merge!(options[:default_headers])
    end
    final_options[:cache] = options[:cache] if options[:cache]
    final_options[:url] = options[:url] if options[:url]
    final_options[:user] = options[:user] if options[:user]
    final_options
  end

  # Get the default options.
  def self.default_options
    default_headers = {}
    cache = Moneta.new(:Memory)
    {
      default_headers: default_headers,
      cache:           cache,
      url:             "http://localhost:5000/api"
    }
  end

  private_class_method :default_options, :custom_options

  # Mailbooth API
  class Client
    def initialize(client)
      @client = client
    end

    # FIXME
    #
    # @return [Inbox]
    def inbox
      @inbox_resource ||= Inbox.new(@client)
    end
  end

  private

  # FIXME
  class Inbox
    def initialize(client)
      @client = client
    end

    # Create a new inbox.
    #
    # @param body: the object to pass as the request payload
    def create(body)
      @client.inbox.create(body)
    end

    # Delete an existing inbox.
    #
    # @param inbox_identity: 
    def delete(inbox_identity)
      @client.inbox.delete(inbox_identity)
    end

    # Info for existing inbox.
    #
    # @param inbox_identity: 
    def info(inbox_identity)
      @client.inbox.info(inbox_identity)
    end

    # List existing inboxes.
    def list()
      @client.inbox.list()
    end
  end

  SCHEMA = Heroics::Schema.new(MultiJson.load(<<-'HEROICS_SCHEMA'))
{
  "$schema": "http://json-schema.org/draft-04/hyper-schema",
  "definitions": {
    "inbox": {
      "$schema": "http://json-schema.org/draft-04/hyper-schema",
      "title": "FIXME - Inbox",
      "definitions": {
        "id": {
          "description": "unique identifier of inbox",
          "example": 1,
          "type": [
            "integer"
          ]
        },
        "identity": {
          "$ref": "#/definitions/inbox/definitions/id"
        },
        "name": {
          "description": "name of the inbox",
          "example": "My inbox",
          "type": [
            "string"
          ]
        },
        "username": {
          "description": "smtp username for the inbox",
          "example": "fc97223af6917411b7c6b914eff104b024",
          "type": [
            "string"
          ]
        },
        "password": {
          "description": "smtp password for the inbox",
          "example": "c12b3fccb5c7a195311eb5486469",
          "type": [
            "string"
          ]
        },
        "created_at": {
          "description": "when inbox was created",
          "example": "2012-01-01T12:00:00Z",
          "format": "date-time",
          "type": [
            "string"
          ]
        },
        "updated_at": {
          "description": "when inbox was updated",
          "example": "2012-01-01T12:00:00Z",
          "format": "date-time",
          "type": [
            "string"
          ]
        }
      },
      "description": "FIXME",
      "links": [
        {
          "description": "Create a new inbox.",
          "href": "/inboxes",
          "method": "POST",
          "rel": "create",
          "schema": {
            "properties": {
              "name": {
                "type": [
                  "string"
                ]
              }
            },
            "required": [
              "name"
            ],
            "type": [
              "object"
            ]
          },
          "title": "Create"
        },
        {
          "description": "Delete an existing inbox.",
          "href": "/inboxes/{(%23%2Fdefinitions%2Finbox%2Fdefinitions%2Fidentity)}",
          "method": "DELETE",
          "rel": "destroy",
          "title": "Delete"
        },
        {
          "description": "Info for existing inbox.",
          "href": "/inboxes/{(%23%2Fdefinitions%2Finbox%2Fdefinitions%2Fidentity)}",
          "method": "GET",
          "rel": "self",
          "title": "Info"
        },
        {
          "description": "List existing inboxes.",
          "href": "/inboxes",
          "method": "GET",
          "rel": "instances",
          "title": "List"
        }
      ],
      "properties": {
        "id": {
          "$ref": "#/definitions/inbox/definitions/id"
        },
        "name": {
          "$ref": "#/definitions/inbox/definitions/name"
        },
        "username": {
          "$ref": "#/definitions/inbox/definitions/username"
        },
        "password": {
          "$ref": "#/definitions/inbox/definitions/password"
        },
        "created_at": {
          "$ref": "#/definitions/inbox/definitions/created_at"
        },
        "updated_at": {
          "$ref": "#/definitions/inbox/definitions/updated_at"
        }
      },
      "type": [
        "object"
      ]
    }
  },
  "properties": {
    "inbox": {
      "$ref": "#/definitions/inbox"
    }
  },
  "type": [
    "object"
  ],
  "description": "Mailbooth API",
  "id": "mailbooth-api",
  "links": [
    {
      "href": "http://mailbooth.herokuapp.com/api",
      "rel": "self"
    }
  ],
  "title": "Mailbooth API"
}
HEROICS_SCHEMA
end
