# frozen_string_literal: true

require_relative 'tasks/initialise'
require_relative 'tasks/generate'
require_relative 'tasks/ca'
require_relative 'tasks/crl'
require_relative 'tasks/dh'
require_relative 'tasks/client'
require_relative 'tasks/server'
require_relative 'tasks/certificate'

module RakeEasyRSA
  module Tasks
  end
end
