# frozen_string_literal: true

require 'spec_helper'

require_relative '../../support/shared_examples/global_parameters'
require_relative '../../support/shared_examples/ssl_parameters'
require_relative '../../support/shared_examples/algorithm_parameters'
require_relative '../../support/shared_examples/encrypt_key_parameters'

describe RakeEasyRSA::TaskSets::PKI do
  include_context 'rake'

  def define_tasks(opts = {}, &block)
    subject.define(opts, &block)
  end

  it 'adds all tasks in the provided namespace when supplied' do
    define_tasks(namespace: :pki)

    %w[pki:initialise
       pki:generate
       pki:ca:create
       pki:crl:generate
       pki:dh:generate
       pki:client:create
       pki:server:create
       pki:certificate:revoke
       pki:certificate:renew].each do |task_name|
      expect(Rake::Task.task_defined?(task_name))
        .to(be(true), task_name)
    end
  end

  it 'adds all tasks in the root namespace when none supplied' do
    define_tasks

    expect(Rake.application)
      .to(have_tasks_defined(
            %w[initialise
               generate
               ca:create
               crl:generate
               dh:generate
               client:create
               server:create
               certificate:revoke
               certificate:renew]
          ))
  end

  describe 'initialise task' do
    it 'uses a name of initialise by default' do
      define_tasks

      expect(Rake::Task.task_defined?('initialise'))
        .to(be(true))
    end

    it 'uses the provided name when supplied' do
      define_tasks(initialise_task_name: :create_directories)

      expect(Rake::Task.task_defined?('create_directories'))
        .to(be(true))
    end

    it 'uses an empty array for argument names by default' do
      define_tasks

      rake_task = Rake::Task['initialise']

      expect(rake_task.creator.argument_names).to(eq([]))
    end

    it 'uses the provided argument names when supplied' do
      define_tasks(argument_names: [:org_name])

      rake_task = Rake::Task['initialise']

      expect(rake_task.creator.argument_names).to(eq([:org_name]))
    end

    it_behaves_like 'a task with global parameters', 'initialise'
    it_behaves_like 'a task with ssl parameters', 'initialise'
  end

  describe 'generate task' do
    it 'uses a name of generate by default' do
      define_tasks

      expect(Rake::Task.task_defined?('generate'))
        .to(be(true))
    end

    it 'uses the provided name when supplied' do
      define_tasks(generate_task_name: :prepare)

      expect(Rake::Task.task_defined?('prepare'))
        .to(be(true))
    end

    it 'uses an empty array for argument names by default' do
      define_tasks

      rake_task = Rake::Task['generate']

      expect(rake_task.creator.argument_names).to(eq([]))
    end

    it 'uses the provided argument names when supplied' do
      define_tasks(argument_names: [:org_name])

      rake_task = Rake::Task['generate']

      expect(rake_task.creator.argument_names).to(eq([:org_name]))
    end
  end

  describe 'ca' do
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

    describe 'create task' do
      it 'uses a name of create by default' do
        define_tasks

        expect(Rake.application)
          .to(have_task_defined('ca:create'))
      end

      it 'uses the provided name when supplied' do
        define_tasks(ca_create_task_name: :build)

        expect(Rake.application)
          .to(have_task_defined('ca:build'))
      end

      it 'uses an empty array for argument names by default' do
        define_tasks

        rake_task = Rake::Task['ca:create']

        expect(rake_task.creator.argument_names).to(eq([]))
      end

      it 'uses the provided argument names when supplied' do
        define_tasks(argument_names: [:org_name])

        rake_task = Rake::Task['ca:create']

        expect(rake_task.creator.argument_names).to(eq([:org_name]))
      end

      it_behaves_like 'a task with global parameters', 'ca:create'
      it_behaves_like 'a task with ssl parameters', 'ca:create'
      it_behaves_like 'a task with algorithm parameters', 'ca:create'
      it_behaves_like 'a task with encrypt key parameters', 'ca:create'
    end
  end

  describe 'crl' do
    it 'adds all crl tasks in the provided namespace when supplied' do
      define_tasks(crl_namespace: :certificate_revocation_list)

      expect(Rake.application)
        .to(have_task_defined('certificate_revocation_list:generate'))
    end

    it 'adds all crl tasks in the crl namespace when none supplied' do
      define_tasks

      expect(Rake.application)
        .to(have_task_defined('crl:generate'))
    end

    describe 'generate task' do
      it 'uses a name of create by default' do
        define_tasks

        expect(Rake.application)
          .to(have_task_defined('crl:generate'))
      end

      it 'uses the provided name when supplied' do
        define_tasks(crl_generate_task_name: :regenerate)

        expect(Rake.application)
          .to(have_task_defined('crl:regenerate'))
      end

      it 'uses an empty array for argument names by default' do
        define_tasks

        rake_task = Rake::Task['crl:generate']

        expect(rake_task.creator.argument_names).to(eq([]))
      end

      it 'uses the provided argument names when supplied' do
        define_tasks(argument_names: [:org_name])

        rake_task = Rake::Task['crl:generate']

        expect(rake_task.creator.argument_names).to(eq([:org_name]))
      end

      it_behaves_like 'a task with global parameters', 'crl:generate'
      it_behaves_like 'a task with ssl parameters', 'crl:generate'
    end
  end

  describe 'dh' do
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

    describe 'generate task' do
      it 'uses a name of create by default' do
        define_tasks

        expect(Rake.application)
          .to(have_task_defined('dh:generate'))
      end

      it 'uses the provided name when supplied' do
        define_tasks(dh_generate_task_name: :regenerate)

        expect(Rake.application)
          .to(have_task_defined('dh:regenerate'))
      end

      it 'uses an empty array for argument names by default' do
        define_tasks

        rake_task = Rake::Task['dh:generate']

        expect(rake_task.creator.argument_names).to(eq([]))
      end

      it 'uses the provided argument names when supplied' do
        define_tasks(argument_names: [:org_name])

        rake_task = Rake::Task['dh:generate']

        expect(rake_task.creator.argument_names).to(eq([:org_name]))
      end

      it_behaves_like 'a task with global parameters', 'dh:generate'
      it_behaves_like 'a task with ssl parameters', 'dh:generate'
    end
  end

  describe 'client' do
    it 'adds all client tasks in the provided namespace when supplied' do
      define_tasks(client_namespace: :client_cert)

      expect(Rake.application)
        .to(have_task_defined('client_cert:create'))
    end

    it 'adds all client tasks in the client namespace when none supplied' do
      define_tasks

      expect(Rake.application)
        .to(have_task_defined('client:create'))
    end

    describe 'create task' do
      it 'uses a name of create by default' do
        define_tasks

        expect(Rake.application)
          .to(have_task_defined('client:create'))
      end

      it 'uses the provided name when supplied' do
        define_tasks(client_create_task_name: :new)

        expect(Rake.application)
          .to(have_task_defined('client:new'))
      end

      it 'uses the default argument names for the task by default' do
        define_tasks

        rake_task = Rake::Task['client:create']

        expect(rake_task.creator.argument_names).to(eq([:filename_base]))
      end

      it 'uses the provided and default argument names for the task ' \
         'when supplied' do
        define_tasks(argument_names: [:org_name])

        rake_task = Rake::Task['client:create']

        expect(rake_task.creator.argument_names)
          .to(eq(%i[org_name filename_base]))
      end

      it_behaves_like 'a task with global parameters', 'client:create'
      it_behaves_like 'a task with ssl parameters', 'client:create'
      it_behaves_like 'a task with algorithm parameters', 'client:create'
      it_behaves_like 'a task with encrypt key parameters', 'client:create'
    end
  end

  describe 'server' do
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

    describe 'create task' do
      it 'uses a name of create by default' do
        define_tasks

        expect(Rake.application)
          .to(have_task_defined('server:create'))
      end

      it 'uses the provided name when supplied' do
        define_tasks(server_create_task_name: :new)

        expect(Rake.application)
          .to(have_task_defined('server:new'))
      end

      it 'uses the default argument names for the task by default' do
        define_tasks

        rake_task = Rake::Task['server:create']

        expect(rake_task.creator.argument_names).to(eq([:filename_base]))
      end

      it 'uses the provided and default argument names for the task ' \
         'when supplied' do
        define_tasks(argument_names: [:org_name])

        rake_task = Rake::Task['server:create']

        expect(rake_task.creator.argument_names)
          .to(eq(%i[org_name filename_base]))
      end

      it_behaves_like 'a task with global parameters', 'server:create'
      it_behaves_like 'a task with ssl parameters', 'server:create'
      it_behaves_like 'a task with algorithm parameters', 'server:create'
      it_behaves_like 'a task with encrypt key parameters', 'server:create'
    end
  end

  describe 'certificate' do
    it 'adds all certificate tasks in the provided namespace when supplied' do
      define_tasks(certificate_namespace: :cert)

      expect(Rake.application)
        .to(have_tasks_defined(
              %w[cert:revoke
                 cert:renew]
            ))
    end

    it 'adds all certificate tasks in the certificate namespace ' \
       'when none supplied' do
      define_tasks

      expect(Rake.application)
        .to(have_tasks_defined(
              %w[certificate:revoke
                 certificate:renew]
            ))
    end

    describe 'revoke task' do
      it 'uses a name of revoke by default' do
        define_tasks

        expect(Rake.application)
          .to(have_task_defined('certificate:revoke'))
      end

      it 'uses the provided name when supplied' do
        define_tasks(certificate_revoke_task_name: :add_to_revocation_list)

        expect(Rake.application)
          .to(have_task_defined('certificate:add_to_revocation_list'))
      end

      it 'uses the default argument names for the task by default' do
        define_tasks

        rake_task = Rake::Task['certificate:revoke']

        expect(rake_task.creator.argument_names)
          .to(eq(%i[filename_base reason]))
      end

      it 'uses the provided and default argument names for the task ' \
         'when supplied' do
        define_tasks(argument_names: [:org_name])

        rake_task = Rake::Task['certificate:revoke']

        expect(rake_task.creator.argument_names)
          .to(eq(%i[org_name filename_base reason]))
      end

      it_behaves_like 'a task with global parameters', 'certificate:revoke'
      it_behaves_like 'a task with ssl parameters', 'certificate:revoke'
    end

    describe 'renew task' do
      it 'uses a name of renew by default' do
        define_tasks

        expect(Rake.application)
          .to(have_task_defined('certificate:renew'))
      end

      it 'uses the provided name when supplied' do
        define_tasks(certificate_renew_task_name: :extend)

        expect(Rake.application)
          .to(have_task_defined('certificate:extend'))
      end

      it 'uses the default argument names for the task by default' do
        define_tasks

        rake_task = Rake::Task['certificate:renew']

        expect(rake_task.creator.argument_names).to(eq([:filename_base]))
      end

      it 'uses the provided and default argument names for the task ' \
         'when supplied' do
        define_tasks(argument_names: [:org_name])

        rake_task = Rake::Task['certificate:renew']

        expect(rake_task.creator.argument_names)
          .to(eq(%i[org_name filename_base]))
      end

      it_behaves_like 'a task with global parameters', 'certificate:renew'
      it_behaves_like 'a task with ssl parameters', 'certificate:renew'
      it_behaves_like 'a task with encrypt key parameters', 'certificate:renew'
    end
  end
end
