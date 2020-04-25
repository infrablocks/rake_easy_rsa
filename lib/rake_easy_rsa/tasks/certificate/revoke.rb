require 'rake_factory'
require 'ruby_easy_rsa'

require_relative '../../mixins/global_parameters'
require_relative '../../mixins/ssl_parameters'

module RakeEasyRSA
  module Tasks
    module Certificate
      class Revoke < RakeFactory::Task
        include Mixins::GlobalParameters
        include Mixins::SSLParameters

        default_name :revoke
        default_argument_names [:filename_base, :reason]
        default_description 'Revoke a certificate of the PKI'

        parameter :reason, default: 'unspecified'

        action do |t, args|
          puts "Revoking certificate '#{args.filename_base}'... "
          reason = args.reason || t.reason
          RubyEasyRSA.revoke(
              t.parameter_values.merge(
                  reason: reason,
                  filename_base: args.filename_base))
          puts 'Done.'
        end
      end
    end
  end
end
