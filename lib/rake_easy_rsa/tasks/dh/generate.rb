require 'rake_factory'
require 'ruby_easy_rsa'

require_relative '../../mixins/global_parameters'
require_relative '../../mixins/ssl_parameters'
require_relative '../../mixins/easy_rsa_ensure_prerequisite'

module RakeEasyRSA
  module Tasks
    module DH
      class Generate < RakeFactory::Task
        include Mixins::GlobalParameters
        include Mixins::SSLParameters
        include Mixins::EasyRSAEnsurePrerequisite

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
