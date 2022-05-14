# frozen_string_literal: true

require 'require_all'
require 'draper'
require 'core'
require 'bcrypt'

Mongoid.load!('config/mongoid.yml', ENV['RACK_ENV'].to_sym || :development)

require './controllers/base'
require_rel 'controllers/**/*.rb'

map("/tokens") { run Controllers::Tokens.new }
map("/") { run Controllers::Templates.new }