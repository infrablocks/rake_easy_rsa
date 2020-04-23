require 'rake_factory'
require 'ruby_easy_rsa'

module RakeEasyRSA
  module Tasks
    module Certificate
      class Renew < RakeFactory::Task
        default_name :renew
        default_argument_names [:filename_base]
        default_description "Renew a certificate of the PKI"

        parameter :directory
        parameter :extensions_directory
        parameter :openssl_binary
        parameter :ssl_configuration
        parameter :safe_configuration
        parameter :vars
        parameter :batch, default: true
        parameter :input_password
        parameter :output_password

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
