require 'rake_factory'
require 'ruby_easy_rsa'

require_relative '../../mixins/global_parameters'
require_relative '../../mixins/ssl_parameters'
require_relative '../../mixins/algorithm_parameters'
require_relative '../../mixins/encrypt_key_parameters'

module RakeEasyRSA
  module Tasks
    module CA
      class Create < RakeFactory::Task
        include Mixins::GlobalParameters
        include Mixins::SSLParameters
        include Mixins::AlgorithmParameters
        include Mixins::EncryptKeyParameters

        default_name :create
        default_description "Create the CA certificate for the PKI"

        action do |t|
          puts "Creating CA certificate... "
          RubyEasyRSA.build_ca(t.parameter_values)
          puts "Done."
        end
      end
    end
  end
end
