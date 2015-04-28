module TwitterAPI
  class ResultSet
    attr_reader :path, :document, :results
    attr_reader :error_message, :error_code
    attr_reader :count, :max_id, :since_id, :next_results_query, :refresh_query

    def initialize(json_string, path)
      @path = path
      begin
        @document = JSON.parse(json_string)
        check_error
        unless error?
          parse_metadata('search_metadata')  # TODO: unhardcode container names
          parse_results('statuses')
        end
      rescue JSON::ParserError
        @error_message = 'Error when parsing JSON document'
      end
    end

    def error?
      !(@error_message.nil? || @error_message.empty?)
    end

    protected

    def check_error
      return unless @document.keys.first == 'errors'
      @error_message = @document['errors'][0]['message']  # TODO: handle the whole array of errors
      @error_code = @document['errors'][0]['code']
    end

    def parse_metadata(container)
      {
        count: 'count',
        max_id: 'max_id',
        since_id: 'since_id',
        next_results_query: 'next_results',
        refresh_query: 'refresh_url'
      }.each do |i_var, field|
        instance_variable_set("@#{ i_var }".to_sym, @document[container][field])
      end
    end

    def parse_results(container)
      @results = @document[container]
    end
  end
end
