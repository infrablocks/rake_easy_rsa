require 'rake_factory'
require 'ruby_easy_rsa'

require_relative '../mixins/global_parameters'

module RakeEasyRSA
  module Tasks
    module DH
      class Generate < RakeFactory::Task
        include Mixins::GlobalParameters

        default_name :generate
        default_description(
            "Generate Diffie-Hellman parameters for the PKI")

        action do |t|
          puts "Generating Diffie-Hellman parameters... "
          RubyEasyRSA.gen_dh(t.parameter_values)
          puts "Done."
        end
      end
    end
  end
end
