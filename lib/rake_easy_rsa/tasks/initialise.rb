# frozen_string_literal: true

require 'rake_factory'
require 'ruby_easy_rsa'

require_relative '../mixins/global_parameters'
require_relative '../mixins/ssl_parameters'
require_relative '../mixins/gitkeep_parameters'
require_relative '../mixins/easy_rsa_ensure_prerequisite'

module RakeEasyRSA
  module Tasks
    class Initialise < RakeFactory::Task
      include Mixins::GlobalParameters
      include Mixins::SSLParameters
      include Mixins::GitkeepParameters
      include Mixins::EasyRSAEnsurePrerequisite

      default_name :initialise
      default_description 'Initialise the PKI working directory'

      action do |t|
        puts 'Initialising PKI working directory... '
        RubyEasyRSA.init_pki(t.parameter_values)
        if t.include_gitkeep_files
          File.write("#{t.pki_directory}/private/.gitkeep", '')
          File.write("#{t.pki_directory}/reqs/.gitkeep", '')
        end
        puts 'Done.'
      end
    end
  end
end
