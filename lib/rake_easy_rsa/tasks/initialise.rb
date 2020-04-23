require 'rake_factory'
require 'ruby_easy_rsa'

module RakeEasyRSA
  module Tasks
    class Initialise < RakeFactory::Task
      default_name :initialise
      default_description "Initialise the PKI working directory"

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
        puts "Initialising PKI working directory... "
        RubyEasyRSA.init_pki(t.parameter_values)
        puts "Done."
      end
    end
  end
end
