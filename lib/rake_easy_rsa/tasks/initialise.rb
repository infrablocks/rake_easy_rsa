require 'rake_factory'
require 'ruby_easy_rsa'

require_relative '../mixins/global_parameters'
require_relative '../mixins/ssl_parameters'
require_relative '../mixins/gitkeep_parameters'

module RakeEasyRSA
  module Tasks
    class Initialise < RakeFactory::Task
      include Mixins::GlobalParameters
      include Mixins::SSLParameters
      include Mixins::GitkeepParameters

      default_name :initialise
      default_description "Initialise the PKI working directory"

      action do |t|
        puts "Initialising PKI working directory... "
        RubyEasyRSA.init_pki(t.parameter_values)
        if t.include_gitkeep_files
          File.open("#{t.pki_directory}/private/.gitkeep", 'w') do |f|
            f.write('')
          end
          File.open("#{t.pki_directory}/reqs/.gitkeep", 'w') do |f|
            f.write('')
          end
        end
        puts "Done."
      end
    end
  end
end
