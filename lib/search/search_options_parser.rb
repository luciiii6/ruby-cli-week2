# frozen_string_literal: true

require 'optparse'
require './lib/search/options/license_option'

class SearchOptionsParser
  def self.parse(args)
    options = []
    parser = OptionParser.new do |opts|
      opts.on('--license LICENSE') { |license| options << LicenseOption.new(license) }
    end
    parser.parse(args)
    options
  end
end
