# frozen_string_literal: true

require 'bundler'
Bundler.require :test

def fp(path)
  File.join(File.dirname(__FILE__), path)
end

ENV['RACK_ENV'] = 'test'

Mongoid.load!(fp('../config/mongoid.yml'), :test)

require 'uri/https'
require fp('../controllers/base')

require_rel 'support/**/*.rb'
%w[decorators services controllers].each do |folder|
  require_rel "../#{folder}/**/*.rb"
end
