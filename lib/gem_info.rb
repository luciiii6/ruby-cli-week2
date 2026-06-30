# frozen_string_literal: true

class GemInfo
  def initialize(data)
    @data = data
  end

  def name
    @data['name']
  end

  def info
    @data['info']
  end

  def licenses
    @data['licenses']
  end

  def downloads
    @data['downloads']
  end

  def to_s
    [name, info].join(':')
  end
end
