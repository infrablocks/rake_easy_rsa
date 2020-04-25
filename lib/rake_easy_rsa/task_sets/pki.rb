require 'rake_factory'

require_relative '../tasks'
require_relative '../mixins/global_parameters'
require_relative '../mixins/ssl_parameters'
require_relative '../mixins/algorithm_parameters'
require_relative '../mixins/encrypt_key_parameters'

module RakeEasyRSA
  module TaskSets
    class PKI < RakeFactory::TaskSet
      prepend RakeFactory::Namespaceable

      include Mixins::GlobalParameters
      include Mixins::SSLParameters
      include Mixins::AlgorithmParameters
      include Mixins::EncryptKeyParameters

      parameter :initialise_task_name, default: :initialise
      parameter :generate_task_name, default: :generate

      parameter :ca_namespace, default: :ca
      parameter :ca_create_task_name, default: :create

      parameter :crl_namespace, default: :crl
      parameter :crl_generate_task_name, default: :generate

      parameter :dh_namespace, default: :dh
      parameter :dh_generate_task_name, default: :generate

      parameter :client_namespace, default: :client
      parameter :client_create_task_name, default: :create

      parameter :server_namespace, default: :server
      parameter :server_create_task_name, default: :create

      parameter :certificate_namespace, default: :certificate
      parameter :certificate_revoke_task_name, default: :revoke
      parameter :certificate_renew_task_name, default: :renew

      task Tasks::Initialise,
          name: RakeFactory::DynamicValue.new { |ts|
            ts.initialise_task_name
          }
      task Tasks::Generate,
          name: RakeFactory::DynamicValue.new { |ts|
            ts.generate_task_name
          },
          initialise_task_name: RakeFactory::DynamicValue.new { |ts|
            ts.initialise_task_name
          },
          ca_create_task_name: RakeFactory::DynamicValue.new { |ts|
            "#{ts.ca_namespace}:#{ts.ca_create_task_name}".to_sym
          },
          crl_generate_task_name: RakeFactory::DynamicValue.new { |ts|
            "#{ts.crl_namespace}:#{ts.crl_generate_task_name}".to_sym
          },
          dh_generate_task_name: RakeFactory::DynamicValue.new { |ts|
            "#{ts.dh_namespace}:#{ts.dh_generate_task_name}".to_sym
          }
      task Tasks::CA::Create,
          name: RakeFactory::DynamicValue.new { |ts|
            ts.ca_create_task_name
          }
      task Tasks::CRL::Generate,
          name: RakeFactory::DynamicValue.new { |ts|
            ts.crl_generate_task_name
          }
      task Tasks::DH::Generate,
          name: RakeFactory::DynamicValue.new { |ts|
            ts.dh_generate_task_name
          }
      task Tasks::Client::Create,
          name: RakeFactory::DynamicValue.new { |ts|
            ts.client_create_task_name
          }
      task Tasks::Server::Create,
          name: RakeFactory::DynamicValue.new { |ts|
            ts.server_create_task_name
          }
      task Tasks::Certificate::Revoke,
          name: RakeFactory::DynamicValue.new { |ts|
            ts.certificate_revoke_task_name
          }
      task Tasks::Certificate::Renew,
          name: RakeFactory::DynamicValue.new { |ts|
            ts.certificate_renew_task_name
          }

      def define_on(application)
        around_define(application) do
          self.class.tasks.each do |task_definition|
            ns = case task_definition.klass.to_s
            when /CA/
              ca_namespace
            when /CRL/
              crl_namespace
            when /DH/
              dh_namespace
            when /Client/
              client_namespace
            when /Server/
              server_namespace
            when /Certificate/
              certificate_namespace
            else
              nil
            end

            if ns
              application.in_namespace(ns) do
                task_definition
                    .for_task_set(self)
                    .define_on(application)
              end
            else
              task_definition
                  .for_task_set(self)
                  .define_on(application)
            end
          end
        end
      end
    end
  end
end
