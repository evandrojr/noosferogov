#!/usr/bin/env ruby

# require 'conformist'
require 'csv'
require 'jazz_fingers'
require 'awesome_print'

# csv    = CSV.open "#{__dir__}/data/pids.csv", :skip_first => true
#
# schema.conform CSV.open('~/file_with_headers.csv'), :skip_first => true
#
# ap csv
# schema = Conformist.new do
#   column :callsign, 1
#   column :latitude, 1, 2, 3
#   column :longitude, 3, 4, 5
#   column :name, 0 do |value|
#     value.upcase
#   end
# end
#
# ap schema
#
# schema.conform(csv).each do |transmitter|
#   ap transmitter.callsign
# end
#

pids = CSV.read("#{__dir__}/data/pids.csv")

pids.each do |p|
  ap p
end
