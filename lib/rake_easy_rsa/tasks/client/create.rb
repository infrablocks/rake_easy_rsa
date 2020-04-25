require 'rake_factory'
require 'ruby_easy_rsa'

require_relative '../../mixins/global_parameters'
require_relative '../../mixins/ssl_parameters'
require_relative '../../mixins/algorithm_parameters'
require_relative '../../mixins/encrypt_key_parameters'
require_relative '../../mixins/easy_rsa_ensure_prerequisite'

module RakeEasyRSA
  module Tasks
    module Client
      class Create < RakeFactory::Task
        include Mixins::GlobalParameters
        include Mixins::SSLParameters
        include Mixins::AlgorithmParameters
        include Mixins::EncryptKeyParameters
        include Mixins::EasyRSAEnsurePrerequisite

        default_name :create
        default_argument_names [:filename_base]
        default_description "Create a client certificate for the PKI"

        action do |t, args|
          puts "Creating client certificate '#{args.filename_base}'... "
          RubyEasyRSA.build_client_full(
              t.parameter_values.merge(
                  filename_base: args.filename_base))
          puts "Done."
        end
      end
    end
  end
end
