require "sinatra/base"
require "pg"
require "pry"
require "bcrypt"

require_relative "server"

run Portfolio::Server