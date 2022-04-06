# frozen_string_literal: true

require 'rake_factory'
require 'ruby_easy_rsa'

require_relative '../../mixins/global_parameters'
require_relative '../../mixins/ssl_parameters'
require_relative '../../mixins/algorithm_parameters'
require_relative '../../mixins/encrypt_key_parameters'
require_relative '../../mixins/gitkeep_parameters'
require_relative '../../mixins/easy_rsa_ensure_prerequisite'

module RakeEasyRSA
  module Tasks
    module CA
      class Create < RakeFactory::Task
        include Mixins::GlobalParameters
        include Mixins::SSLParameters
        include Mixins::AlgorithmParameters
        include Mixins::EncryptKeyParameters
        include Mixins::GitkeepParameters
        include Mixins::EasyRSAEnsurePrerequisite

        default_name :create
        default_description 'Create the CA certificate for the PKI'

        action do |t|
          puts 'Creating CA certificate... '
          RubyEasyRSA.build_ca(t.parameter_values)
          if t.include_gitkeep_files
            %w[certs_by_serial/.gitkeep
               issued/.gitkeep
               renewed/certs_by_serial/.gitkeep
               renewed/private_by_serial/.gitkeep
               renewed/reqs_by_serial/.gitkeep
               revoked/certs_by_serial/.gitkeep
               revoked/private_by_serial/.gitkeep
               revoked/reqs_by_serial/.gitkeep].each do |gitkeep_file|
              File.write("#{t.pki_directory}/#{gitkeep_file}", '')
            end
          end
          puts 'Done.'
        end
      end
    end
  end
end
