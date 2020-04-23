require 'rake_factory'
require 'ruby_easy_rsa'

module RakeEasyRSA
  module Tasks
    module Client
      class Create < RakeFactory::Task
        default_name :create
        default_argument_names [:common_name]
        default_description "Create a client certificate for the PKI"

        parameter :directory

        action do |t, args|
          puts "Creating client certificate... "
          RubyEasyRSA.build_client_full(
              directory: t.directory,
              common_name: args.common_name)
          puts "Done."
        end
      end
    end
  end
end
