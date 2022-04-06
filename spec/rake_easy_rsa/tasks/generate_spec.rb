# frozen_string_literal: true

require 'spec_helper'

describe RakeEasyRSA::Tasks::Generate do
  include_context 'rake'

  before do
    stub_output
    stub_ruby_easy_rsa
  end

  def default_additional_tasks
    [
      :clean,
      { ca: [:create] },
      { crl: [:generate] },
      { dh: [:generate] }
    ]
  end

  def define_additional_tasks(additional_tasks)
    additional_tasks.each do |t|
      if t.is_a?(Hash)
        inner_ns, inner_tasks = t.first
        namespace inner_ns do
          inner_tasks.each { |it| task it }
        end
      else
        task t
      end
    end
  end

  def define_sut_task(opts, &block)
    described_class.define(opts) do |t|
      block&.call(t)
    end
  end

  def define_tasks(opts = {}, &block)
    ns = opts[:namespace] || :pki
    additional_tasks = opts[:additional_tasks] || default_additional_tasks

    namespace ns do
      define_additional_tasks(additional_tasks)
      define_sut_task(opts, &block)
    end
  end

  describe 'task definition' do
    it 'adds an generate task in the namespace in which it is created' do
      define_tasks

      expect(Rake.application)
        .to(have_task_defined('pki:generate'))
    end

    it 'gives the generate task a description' do
      define_tasks

      expect(Rake::Task['pki:generate'].full_comment)
        .to(eq('Generate all pre-requisites for managing the PKI'))
    end

    it 'allows multiple fetch tasks to be declared' do
      define_tasks(namespace: :pki1)
      define_tasks(namespace: :pki2)

      expect(Rake.application)
        .to(have_tasks_defined(
              %w[pki1:generate
                 pki2:generate]
            ))
    end
  end

  describe 'parameters' do
    it 'allows the task name to be overridden' do
      define_tasks(name: :prepare)

      expect(Rake::Task['pki:prepare']).not_to be_nil
    end

    # rubocop:disable RSpec/MultipleExpectations
    it 'allows the initialise task to be overridden' do
      define_tasks(
        additional_tasks: [
          :bootstrap,
          { ca: [:create] },
          { crl: [:generate] },
          { dh: [:generate] }
        ]
      ) do |t|
        t.initialise_task_name = :bootstrap
      end

      generate_task = Rake::Task['pki:generate']

      allow(Rake::Task['pki:bootstrap']).to(receive(:invoke))
      allow(Rake::Task['pki:ca:create']).to(receive(:invoke))
      allow(Rake::Task['pki:crl:generate']).to(receive(:invoke))
      allow(Rake::Task['pki:dh:generate']).to(receive(:invoke))

      generate_task.invoke

      expect(Rake::Task['pki:bootstrap'])
        .to(have_received(:invoke).ordered)
      expect(Rake::Task['pki:ca:create'])
        .to(have_received(:invoke).ordered)
      expect(Rake::Task['pki:crl:generate'])
        .to(have_received(:invoke).ordered)
      expect(Rake::Task['pki:dh:generate'])
        .to(have_received(:invoke).ordered)
    end
    # rubocop:enable RSpec/MultipleExpectations

    # rubocop:disable RSpec/MultipleExpectations
    it 'allows the CA create task to be overridden' do
      define_tasks(
        additional_tasks: [
          :initialise,
          { ca: [:build] },
          { crl: [:generate] },
          { dh: [:generate] }
        ]
      ) do |t|
        t.ca_create_task_name = :'ca:build'
      end

      generate_task = Rake::Task['pki:generate']

      allow(Rake::Task['pki:initialise']).to(receive(:invoke))
      allow(Rake::Task['pki:ca:build']).to(receive(:invoke))
      allow(Rake::Task['pki:crl:generate']).to(receive(:invoke))
      allow(Rake::Task['pki:dh:generate']).to(receive(:invoke))

      generate_task.invoke

      expect(Rake::Task['pki:initialise'])
        .to(have_received(:invoke).ordered)
      expect(Rake::Task['pki:ca:build'])
        .to(have_received(:invoke).ordered)
      expect(Rake::Task['pki:crl:generate'])
        .to(have_received(:invoke).ordered)
      expect(Rake::Task['pki:dh:generate'])
        .to(have_received(:invoke).ordered)
    end
    # rubocop:enable RSpec/MultipleExpectations

    # rubocop:disable RSpec/MultipleExpectations
    it 'allows the CRL generate task to be overridden' do
      define_tasks(
        additional_tasks: [
          :initialise,
          { ca: [:create] },
          { crl: [:regenerate] },
          { dh: [:generate] }
        ]
      ) do |t|
        t.crl_generate_task_name = :'crl:regenerate'
      end

      generate_task = Rake::Task['pki:generate']

      allow(Rake::Task['pki:initialise']).to(receive(:invoke).ordered)
      allow(Rake::Task['pki:ca:create']).to(receive(:invoke).ordered)
      allow(Rake::Task['pki:crl:regenerate']).to(receive(:invoke).ordered)
      allow(Rake::Task['pki:dh:generate']).to(receive(:invoke).ordered)

      generate_task.invoke

      expect(Rake::Task['pki:initialise'])
        .to(have_received(:invoke).ordered)
      expect(Rake::Task['pki:ca:create'])
        .to(have_received(:invoke).ordered)
      expect(Rake::Task['pki:crl:regenerate'])
        .to(have_received(:invoke).ordered)
      expect(Rake::Task['pki:dh:generate'])
        .to(have_received(:invoke).ordered)
    end
    # rubocop:enable RSpec/MultipleExpectations

    # rubocop:disable RSpec/MultipleExpectations
    it 'allows the DH generate task to be overridden' do
      define_tasks(
        additional_tasks: [
          :initialise,
          { ca: [:create] },
          { crl: [:generate] },
          { dh: [:initialise] }
        ]
      ) do |t|
        t.dh_generate_task_name = :'dh:initialise'
      end

      generate_task = Rake::Task['pki:generate']

      allow(Rake::Task['pki:initialise']).to(receive(:invoke))
      allow(Rake::Task['pki:ca:create']).to(receive(:invoke))
      allow(Rake::Task['pki:crl:generate']).to(receive(:invoke))
      allow(Rake::Task['pki:dh:initialise']).to(receive(:invoke))

      generate_task.invoke

      expect(Rake::Task['pki:initialise'])
        .to(have_received(:invoke).ordered)
      expect(Rake::Task['pki:ca:create'])
        .to(have_received(:invoke).ordered)
      expect(Rake::Task['pki:crl:generate'])
        .to(have_received(:invoke).ordered)
      expect(Rake::Task['pki:dh:initialise'])
        .to(have_received(:invoke).ordered)
    end
    # rubocop:enable RSpec/MultipleExpectations
  end

  def stub_output
    %i[print puts].each do |method|
      allow($stdout).to(receive(method))
      allow($stderr).to(receive(method))
    end
  end

  def stub_ruby_easy_rsa
    %i[
      init_pki build_ca gen_dh gen_req sign_req build_client_full
      build_server_full revoke gen_crl update_db show_req
      show_cert import_req export_p7 export_p12 set_rsa_pass
      set_ec_pass
    ].each do |method|
      allow(RubyEasyRSA).to(receive(method))
    end
  end
end
