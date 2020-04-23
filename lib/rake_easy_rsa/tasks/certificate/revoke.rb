require 'rake_factory'
require 'ruby_easy_rsa'

require_relative '../mixins/global_parameters'

module RakeEasyRSA
  module Tasks
    module Certificate
      class Revoke < RakeFactory::Task
        include Mixins::GlobalParameters

        default_name :revoke
        default_argument_names [:filename_base]
        default_description "Revoke a certificate of the PKI"

        action do |t, args|
          puts "Revoking certificate '#{args.filename_base}'... "
          RubyEasyRSA.revoke(
              t.parameter_values.merge(
                  filename_base: args.filename_base))
          puts "Done."
        end
      end
    end
  end
end
