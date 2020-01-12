# frozen_string_literal: true

require 'dry-types'

module LevelTravel
  module Types
    include Dry.Types(:params, :strict, default: :strict)

    StrippedString = Types::Strict::String.constructor(&:strip)
    ArrayOfIntegers = Types.Array(Types::Strict::Integer)
  end
end
