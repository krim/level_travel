# frozen_string_literal: true

module LevelTravel
  module Settings
    module_function

    DEFAULT_TIMEOUT = 10

    def api_token
      @api_token
    end

    def api_token=(token)
      @api_token = token
    end

    def timeout
      @timeout || DEFAULT_TIMEOUT
    end

    def timeout=(seconds)
      @timeout = seconds
    end
  end
end
