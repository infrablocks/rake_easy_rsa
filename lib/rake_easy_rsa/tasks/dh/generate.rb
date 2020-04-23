require 'rake_factory'
require 'ruby_easy_rsa'

module RakeEasyRSA
  module Tasks
    module DH
      class Generate < RakeFactory::Task
        default_name :generate
        default_description(
            "Generate Diffie-Hellman parameters for the PKI")

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
          puts "Generating Diffie-Hellman parameters... "
          RubyEasyRSA.gen_dh(t.parameter_values)
          puts "Done."
        end
      end
    end
  end
end
