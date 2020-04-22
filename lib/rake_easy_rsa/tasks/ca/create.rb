require 'rake_factory'
require 'ruby_easy_rsa'

module RakeEasyRSA
  module Tasks
    module CA
      class Create < RakeFactory::Task
        default_name :create
        default_description "Create the CA certificate for the PKI"

        parameter :directory

        action do |t|
          puts "Creating CA certificate... "
          RubyEasyRSA.build_ca(
              directory: t.directory)
          puts "Done."
        end
      end
    end
  end
end
