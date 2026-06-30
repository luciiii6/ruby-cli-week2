# frozen_string_literal: true

require 'optparse'
require './lib/search/options/license_option'
require './lib/search/options/most_downloads_first_option'
require './lib/errors/invalid_option_error'

class SearchOptionsParser
  def self.parse(args)
    options = []
    parser = OptionParser.new do |opts|
      opts.on('--license LICENSE') { |license| options << LicenseOption.new(license) }
      opts.on('--most-downloads-first') { options << MostDownloadsFirstOption.new }
    end
    parser.parse(args)
    options
  rescue OptionParser::ParseError => e
    raise InvalidOptionError, e.message
  end
end
