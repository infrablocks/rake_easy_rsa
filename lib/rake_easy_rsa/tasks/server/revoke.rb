require 'rake_factory'
require 'ruby_easy_rsa'

module RakeEasyRSA
  module Tasks
    module Server
      class Revoke < RakeFactory::Task
        default_name :revoke
        default_argument_names [:filename_base]
        default_description "Revoke a server certificate for the PKI"

        parameter :directory

        action do |t, args|
          puts "Revoking server certificate '#{args.filename_base}'... "
          RubyEasyRSA.revoke(
              directory: t.directory,
              filename_base: args.filename_base)
          puts "Done."
        end
      end
    end
  end
end
