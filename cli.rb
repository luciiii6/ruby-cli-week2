# frozen_string_literal: true

require 'bundler/setup'
require './lib/program'

result = Program.new.execute(ARGV)
puts result.exit_description

exit(result.exit_code)
