require 'rake_factory'
require 'ruby_easy_rsa'

module RakeEasyRSA
  module Tasks
    module CA
      class Create < RakeFactory::Task
        default_name :create
        default_description "Create the CA certificate for the PKI"

        parameter :directory
        parameter :extensions_directory
        parameter :openssl_binary
        parameter :ssl_configuration
        parameter :safe_configuration
        parameter :vars
        parameter :batch, default: true
        parameter :input_password
        parameter :output_password

        action do |t|
          puts "Creating CA certificate... "
          RubyEasyRSA.build_ca(t.parameter_values)
          puts "Done."
        end
      end
    end
  end
end
