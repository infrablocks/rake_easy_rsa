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

        action do |t|
          puts "Generating Diffie-Hellman parameters... "
          RubyEasyRSA.gen_dh(
              directory: t.directory)
          puts "Done."
        end
      end
    end
  end
end
