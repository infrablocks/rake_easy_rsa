require 'rake_factory'
require 'ruby_easy_rsa'

module RakeEasyRSA
  module Tasks
    class Initialise < RakeFactory::Task
      default_name :initialise
      default_description "Initialise the PKI working directory"

      parameter :directory

      action do |t|
        puts "Initialising PKI working directory... "
        RubyEasyRSA.init_pki(
            directory: t.directory)
        puts "Done."
      end
    end
  end
end
