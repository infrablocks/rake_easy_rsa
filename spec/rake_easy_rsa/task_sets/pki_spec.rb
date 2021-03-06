require 'spec_helper'

require_relative '../../support/shared_examples/global_parameters'
require_relative '../../support/shared_examples/ssl_parameters'
require_relative '../../support/shared_examples/algorithm_parameters'
require_relative '../../support/shared_examples/encrypt_key_parameters'

describe RakeEasyRSA::TaskSets::PKI do
  include_context :rake

  def define_tasks(opts = {}, &block)
    subject.define(opts, &block)
  end

  it 'adds all tasks in the provided namespace when supplied' do
    define_tasks(namespace: :pki)

    [
        'pki:initialise',
        'pki:generate',
        'pki:ca:create',
        'pki:crl:generate',
        'pki:dh:generate',
        'pki:client:create',
        'pki:server:create',
        'pki:certificate:revoke',
        'pki:certificate:renew',
    ].each do |task_name|
      expect(Rake::Task.task_defined?(task_name))
          .to(be(true), task_name)
    end
  end

  it 'adds all tasks in the root namespace when none supplied' do
    define_tasks

    [
        'initialise',
        'generate',
        'ca:create',
        'crl:generate',
        'dh:generate',
        'client:create',
        'server:create',
        'certificate:revoke',
        'certificate:renew',
    ].each do |task_name|
      expect(Rake::Task.task_defined?(task_name)).to(be(true))
    end
  end

  context 'initialise task' do
    it 'uses a name of initialise by default' do
      define_tasks

      expect(Rake::Task.task_defined?("initialise"))
          .to(be(true))
    end

    it 'uses the provided name when supplied' do
      define_tasks(initialise_task_name: :create_directories)

      expect(Rake::Task.task_defined?("create_directories"))
          .to(be(true))
    end

    it_behaves_like "a task with global parameters", "initialise"
    it_behaves_like "a task with ssl parameters", "initialise"
  end

  context 'generate task' do
    it 'uses a name of generate by default' do
      define_tasks

      expect(Rake::Task.task_defined?("generate"))
          .to(be(true))
    end

    it 'uses the provided name when supplied' do
      define_tasks(generate_task_name: :prepare)

      expect(Rake::Task.task_defined?("prepare"))
          .to(be(true))
    end
  end

  context 'ca' do
    it 'adds all ca tasks in the provided namespace when supplied' do
      define_tasks(ca_namespace: :certificate_authority)

      expect(Rake::Task
          .task_defined?('certificate_authority:create'))
          .to(be(true))
    end

    it 'adds all ca tasks in the ca namespace when none supplied' do
      define_tasks

      expect(Rake::Task.task_defined?('ca:create'))
          .to(be(true))
    end

    context 'create task' do
      it 'uses a name of create by default' do
        define_tasks

        expect(Rake::Task.task_defined?("ca:create"))
            .to(be(true))
      end

      it 'uses the provided name when supplied' do
        define_tasks(ca_create_task_name: :build)

        expect(Rake::Task.task_defined?("ca:build"))
            .to(be(true))
      end

      it_behaves_like "a task with global parameters", "ca:create"
      it_behaves_like "a task with ssl parameters", "ca:create"
      it_behaves_like "a task with algorithm parameters", "ca:create"
      it_behaves_like "a task with encrypt key parameters", "ca:create"
    end
  end

  context 'crl' do
    it 'adds all crl tasks in the provided namespace when supplied' do
      define_tasks(crl_namespace: :certificate_revocation_list)

      expect(Rake::Task.task_defined?('certificate_revocation_list:generate'))
          .to(be(true))
    end

    it 'adds all crl tasks in the crl namespace when none supplied' do
      define_tasks

      expect(Rake::Task.task_defined?('crl:generate'))
          .to(be(true))
    end

    context 'generate task' do
      it 'uses a name of create by default' do
        define_tasks

        expect(Rake::Task.task_defined?("crl:generate"))
            .to(be(true))
      end

      it 'uses the provided name when supplied' do
        define_tasks(crl_generate_task_name: :regenerate)

        expect(Rake::Task.task_defined?("crl:regenerate"))
            .to(be(true))
      end

      it_behaves_like "a task with global parameters", "crl:generate"
      it_behaves_like "a task with ssl parameters", "crl:generate"
    end
  end

  context 'dh' do
    it 'adds all dh tasks in the provided namespace when supplied' do
      define_tasks(dh_namespace: :diffie_helman)

      expect(Rake::Task.task_defined?('diffie_helman:generate'))
          .to(be(true))
    end

    it 'adds all dh tasks in the dh namespace when none supplied' do
      define_tasks

      expect(Rake::Task.task_defined?('dh:generate'))
          .to(be(true))
    end

    context 'generate task' do
      it 'uses a name of create by default' do
        define_tasks

        expect(Rake::Task.task_defined?("dh:generate"))
            .to(be(true))
      end

      it 'uses the provided name when supplied' do
        define_tasks(dh_generate_task_name: :regenerate)

        expect(Rake::Task.task_defined?("dh:regenerate"))
            .to(be(true))
      end

      it_behaves_like "a task with global parameters", "dh:generate"
      it_behaves_like "a task with ssl parameters", "dh:generate"
    end
  end

  context 'client' do
    it 'adds all client tasks in the provided namespace when supplied' do
      define_tasks(client_namespace: :client_cert)

      expect(Rake::Task.task_defined?('client_cert:create'))
          .to(be(true))
    end

    it 'adds all client tasks in the client namespace when none supplied' do
      define_tasks

      expect(Rake::Task.task_defined?('client:create'))
          .to(be(true))
    end

    context 'create task' do
      it 'uses a name of create by default' do
        define_tasks

        expect(Rake::Task.task_defined?("client:create"))
            .to(be(true))
      end

      it 'uses the provided name when supplied' do
        define_tasks(client_create_task_name: :new)

        expect(Rake::Task.task_defined?("client:new"))
            .to(be(true))
      end

      it_behaves_like "a task with global parameters", "client:create"
      it_behaves_like "a task with ssl parameters", "client:create"
      it_behaves_like "a task with algorithm parameters", "client:create"
      it_behaves_like "a task with encrypt key parameters", "client:create"
    end
  end

  context 'server' do
    it 'adds all server tasks in the provided namespace when supplied' do
      define_tasks(server_namespace: :server_cert)

      expect(Rake::Task.task_defined?('server_cert:create'))
          .to(be(true))
    end

    it 'adds all server tasks in the server namespace when none supplied' do
      define_tasks

      expect(Rake::Task.task_defined?('server:create'))
          .to(be(true))
    end

    context 'create task' do
      it 'uses a name of create by default' do
        define_tasks

        expect(Rake::Task.task_defined?("server:create"))
            .to(be(true))
      end

      it 'uses the provided name when supplied' do
        define_tasks(server_create_task_name: :new)

        expect(Rake::Task.task_defined?("server:new"))
            .to(be(true))
      end

      it_behaves_like "a task with global parameters", "server:create"
      it_behaves_like "a task with ssl parameters", "server:create"
      it_behaves_like "a task with algorithm parameters", "server:create"
      it_behaves_like "a task with encrypt key parameters", "server:create"
    end
  end

  context 'certificate' do
    it 'adds all certificate tasks in the provided namespace when supplied' do
      define_tasks(certificate_namespace: :cert)

      expect(Rake::Task.task_defined?('cert:revoke'))
          .to(be(true))
      expect(Rake::Task.task_defined?('cert:renew'))
          .to(be(true))
    end

    it 'adds all certificate tasks in the certificate namespace ' +
        'when none supplied' do
      define_tasks

      expect(Rake::Task.task_defined?('certificate:revoke'))
          .to(be(true))
      expect(Rake::Task.task_defined?('certificate:renew'))
          .to(be(true))
    end

    context 'revoke task' do
      it 'uses a name of revoke by default' do
        define_tasks

        expect(Rake::Task.task_defined?("certificate:revoke"))
            .to(be(true))
      end

      it 'uses the provided name when supplied' do
        define_tasks(certificate_revoke_task_name: :add_to_revocation_list)

        expect(Rake::Task
            .task_defined?("certificate:add_to_revocation_list"))
            .to(be(true))
      end

      it_behaves_like "a task with global parameters", "certificate:revoke"
      it_behaves_like "a task with ssl parameters", "certificate:revoke"
    end

    context 'renew task' do
      it 'uses a name of renew by default' do
        define_tasks

        expect(Rake::Task.task_defined?("certificate:renew"))
            .to(be(true))
      end

      it 'uses the provided name when supplied' do
        define_tasks(certificate_renew_task_name: :extend)

        expect(Rake::Task
            .task_defined?("certificate:extend"))
            .to(be(true))
      end

      it_behaves_like "a task with global parameters", "certificate:renew"
      it_behaves_like "a task with ssl parameters", "certificate:renew"
      it_behaves_like "a task with encrypt key parameters", "certificate:renew"
    end
  end
end
