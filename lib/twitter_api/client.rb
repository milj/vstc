module TwitterAPI
  class Client
    def initialize
      consumer = OAuth::Consumer.new(API_KEY, API_SECRET, site: SERVER_URL, scheme: :header)
      token_hash = { oauth_token: ACCESS_TOKEN, oauth_token_secret: ACCESS_TOKEN_SECRET }
      @access_token = OAuth::AccessToken.from_hash(consumer, token_hash)
    end

    # params can be a hash or an escaped query string
    def request(path, params = {})
      url = url_for(path, params)
      response = @access_token.request(:get, url.request_uri)
      result_set = ResultSet.new(response.body, path)
      if (400..599).include?(response.code.to_i)
        fail TwitterAPI::Errors::GeneralError, error_message(url, response, result_set)
      end
      result_set
    end

    private

    def url_for(path, params)
      url = SERVER_URL + path
      case params
      when Hash
        params = params.each_with_object({}) do |(k, v), acc|
          acc[k.to_s.downcase] = CGI.escape(v)
        end
        url << ('?' + params.map { |k, v| "#{ k }=#{ v }" } * '&')
      when String
        url << params
      else
        fail 'Wrong params'
      end
      URI.parse(url)
    end

    def error_message(url, response, result_set)
      message = "Server returned status code #{ response.code } for url #{ url }\nError message: #{ result_set.error_message }"
      message << "\nError code: #{ result_set.error_code }" if result_set.error_code
      message << "\n"
      message
    end
  end
end
