require 'rake_factory'
require 'ruby_easy_rsa'

module RakeEasyRSA
  module Tasks
    module Server
      class Create < RakeFactory::Task
        default_name :create
        default_argument_names [:common_name]
        default_description "Create a server certificate for the PKI"

        parameter :directory

        action do |t, args|
          puts "Creating server certificate... "
          RubyEasyRSA.build_server_full(
              directory: t.directory,
              common_name: args.common_name)
          puts "Done."
        end
      end
    end
  end
end
