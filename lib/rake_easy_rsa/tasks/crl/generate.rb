require 'rake_factory'
require 'ruby_easy_rsa'

module RakeEasyRSA
  module Tasks
    module CRL
      class Generate < RakeFactory::Task
        default_name :generate
        default_description(
            "Generate the certificate revocation list for the PKI")

        parameter :directory

        action do |t|
          puts "Generating CRL... "
          RubyEasyRSA.gen_crl(
              directory: t.directory)
          puts "Done."
        end
      end
    end
  end
end
