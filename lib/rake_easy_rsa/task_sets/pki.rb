# frozen_string_literal: true

require 'rake_factory'

require_relative '../tasks'
require_relative '../mixins/global_parameters'
require_relative '../mixins/ssl_parameters'
require_relative '../mixins/algorithm_parameters'
require_relative '../mixins/encrypt_key_parameters'

module RakeEasyRSA
  module TaskSets
    # rubocop:disable Metrics/ClassLength
    class PKI < RakeFactory::TaskSet
      prepend RakeFactory::Namespaceable

      include Mixins::GlobalParameters
      include Mixins::SSLParameters
      include Mixins::AlgorithmParameters
      include Mixins::EncryptKeyParameters

      parameter :argument_names, default: []

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
             :"#{ts.ca_namespace}:#{ts.ca_create_task_name}"
           },
           crl_generate_task_name: RakeFactory::DynamicValue.new { |ts|
             :"#{ts.crl_namespace}:#{ts.crl_generate_task_name}"
           },
           dh_generate_task_name: RakeFactory::DynamicValue.new { |ts|
             :"#{ts.dh_namespace}:#{ts.dh_generate_task_name}"
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
            namespace = resolve_namespace(task_definition)

            if namespace
              define_in_namespace(namespace, application, task_definition)
            else
              define_at_current_level(application, task_definition)
            end
          end
        end
      end

      private

      def define_in_namespace(namespace, application, task_definition)
        application.in_namespace(namespace) do
          define_at_current_level(application, task_definition)
        end
      end

      def resolve_namespace(task_definition)
        case task_definition.klass.to_s
        when /CA/ then ca_namespace
        when /CRL/ then crl_namespace
        when /DH/ then dh_namespace
        when /Client/ then client_namespace
        when /Server/ then server_namespace
        when /Certificate/ then certificate_namespace
        end
      end

      def define_at_current_level(application, task_definition)
        task_definition
          .for_task_set(self)
          .define_on(application)
      end
    end
    # rubocop:enable Metrics/ClassLength
  end
end
