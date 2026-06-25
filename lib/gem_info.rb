# frozen_string_literal: true

class GemInfo
  attr_reader :name, :info

  def initialize(name, info)
    @name = name
    @info = info
  end
end
