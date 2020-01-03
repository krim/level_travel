# frozen_string_literal: true

require 'dry-types'

module LevelTravel
  module Types
    include Dry.Types(:params, :strict, default: :strict)
  end
end
