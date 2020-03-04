# frozen_string_literal: true

module LevelTravel
  module Settings
    module_function

    DEFAULT_TIMEOUT = 10
    DEFAULT_ERROR_LOAD_PATH = File.expand_path('../config/errors.yml', __dir__).freeze

    def api_token
      @api_token
    end

    def api_token=(token)
      @api_token = token
    end

    def error_load_path
      @error_load_path || DEFAULT_ERROR_LOAD_PATH
    end

    def error_load_path=(paths)
      @error_load_path = paths
    end

    def timeout
      @timeout || DEFAULT_TIMEOUT
    end

    def timeout=(seconds)
      @timeout = seconds
    end
  end
end
