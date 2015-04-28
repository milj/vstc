require 'oauth'
require 'cgi'
require 'json'

require 'twitter_api/errors'
require 'twitter_api/result_set'
require 'twitter_api/client'

module TwitterAPI
  SERVER_URL = 'https://api.twitter.com'

  # TODO: PIN-based authorization

  # TODO: read these from config file:
  # enter your credentials here:
  API_KEY = ''
  API_SECRET = ''
  ACCESS_TOKEN = ''
  ACCESS_TOKEN_SECRET = ''
end
