require 'rake_factory'
require 'ruby_easy_rsa'

require_relative '../../mixins/global_parameters'
require_relative '../../mixins/ssl_parameters'
require_relative '../../mixins/encrypt_key_parameters'

module RakeEasyRSA
  module Tasks
    module Certificate
      class Renew < RakeFactory::Task
        include Mixins::GlobalParameters
        include Mixins::SSLParameters
        include Mixins::EncryptKeyParameters

        default_name :renew
        default_argument_names [:filename_base]
        default_description "Renew a certificate of the PKI"

        action do |t, args|
          puts "Renewing certificate '#{args.filename_base}'... "
          RubyEasyRSA.renew(
              t.parameter_values.merge(
                  filename_base: args.filename_base))
          puts "Done."
        end
      end
    end
  end
end