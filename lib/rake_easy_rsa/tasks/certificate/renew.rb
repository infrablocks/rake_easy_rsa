require 'rake_factory'
require 'ruby_easy_rsa'

require_relative '../mixins/global_parameters'

module RakeEasyRSA
  module Tasks
    module Certificate
      class Renew < RakeFactory::Task
        include Mixins::GlobalParameters

        default_name :renew
        default_argument_names [:filename_base]
        default_description "Renew a certificate of the PKI"

        action do |t, args|
          puts "Renewing certificate '#{args.filename_base}'... "
          RubyEasyRSA.renew(
              t.parameter_values.merge(
                  filename_base: args.filename_base))
          puts "Done."
        end
      end
    end
  end
end
