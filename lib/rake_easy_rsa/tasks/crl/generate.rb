require 'rake_factory'
require 'ruby_easy_rsa'

require_relative '../mixins/global_parameters'
require_relative '../mixins/ssl_parameters'

module RakeEasyRSA
  module Tasks
    module CRL
      class Generate < RakeFactory::Task
        include Mixins::GlobalParameters
        include Mixins::SSLParameters

        default_name :generate
        default_description(
            "Generate the certificate revocation list for the PKI")

        action do |t|
          puts "Generating CRL... "
          RubyEasyRSA.gen_crl(t.parameter_values)
          puts "Done."
        end
      end
    end
  end
end
