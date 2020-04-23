require 'rake_factory'
require 'ruby_easy_rsa'

module RakeEasyRSA
  module Tasks
    module Server
      class Create < RakeFactory::Task
        default_name :create
        default_argument_names [:filename_base]
        default_description "Create a server certificate for the PKI"

        parameter :directory

        action do |t, args|
          puts "Creating server certificate '#{args.filename_base}'... "
          RubyEasyRSA.build_server_full(
              directory: t.directory,
              filename_base: args.filename_base)
          puts "Done."
        end
      end
    end
  end
end
