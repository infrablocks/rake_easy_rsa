require 'rake_factory'
require 'ruby_easy_rsa'

require_relative 'mixins/global_parameters'

module RakeEasyRSA
  module Tasks
    class Initialise < RakeFactory::Task
      include Mixins::GlobalParameters

      default_name :initialise
      default_description "Initialise the PKI working directory"

      action do |t|
        puts "Initialising PKI working directory... "
        RubyEasyRSA.init_pki(t.parameter_values)
        puts "Done."
      end
    end
  end
end
