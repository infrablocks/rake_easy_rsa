require 'rake_factory'
require 'ruby_easy_rsa'

module RakeEasyRSA
  module Tasks
    module Certificate
      class Renew < RakeFactory::Task
        default_name :renew
        default_argument_names [:filename_base]
        default_description "Renew a certificate of the PKI"

        parameter :directory

        action do |t, args|
          puts "Renewing certificate '#{args.filename_base}'... "
          RubyEasyRSA.renew(
              directory: t.directory,
              filename_base: args.filename_base)
          puts "Done."
        end
      end
    end
  end
end
