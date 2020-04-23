require 'rake_factory'
require 'ruby_easy_rsa'

module RakeEasyRSA
  module Tasks
    module Client
      class Create < RakeFactory::Task
        default_name :create
        default_argument_names [:filename_base]
        default_description "Create a client certificate for the PKI"

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
