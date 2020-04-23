require 'spec_helper'

describe RakeEasyRSA::Tasks::Generate do
  include_context :rake

  before(:each) do
    stub_output
    stub_ruby_easy_rsa
  end

  def define_task(opts = {}, &block)
    ns = opts[:namespace] || :pki
    additional_tasks = opts[:additional_tasks] ||
        [
            :clean,
            {ca: [:create]},
            {crl: [:generate]},
            {dh: [:generate]}
        ]

    namespace ns do
      additional_tasks.each do |t|
        if t.is_a?(Hash)
          inner_ns = t.first[0]
          inner_tasks = t.first[1]
          namespace inner_ns do
            inner_tasks.each do |it|
              task it
            end
          end
        else
          task t
        end
      end

      subject.define(opts) do |t|
        block.call(t) if block
      end
    end
  end

  context 'task definition' do
    it 'adds an generate task in the namespace in which it is created' do
      define_task

      expect(Rake::Task['pki:generate']).not_to be_nil
    end

    it 'gives the generate task a description' do
      define_task

      expect(Rake::Task['pki:generate'].full_comment)
          .to(eq('Generate all pre-requisites for managing the PKI'))
    end

    it 'allows multiple fetch tasks to be declared' do
      define_task(namespace: :pki1)
      define_task(namespace: :pki2)

      expect(Rake::Task['pki1:generate']).not_to be_nil
      expect(Rake::Task['pki2:generate']).not_to be_nil
    end
  end

  context 'parameters' do
    it 'allows the task name to be overridden' do
      define_task(name: :prepare)

      expect(Rake::Task['pki:prepare']).not_to be_nil
    end

    it 'allows the initialise task to be overridden' do
      define_task(
          additional_tasks: [
              :bootstrap,
              {ca: [:create]},
              {crl: [:generate]},
              {dh: [:generate]}
          ]) do |t|
        t.initialise_task_name = :bootstrap
      end

      generate_task = Rake::Task['pki:generate']

      expect(Rake::Task['pki:bootstrap']).to(receive(:invoke).ordered)
      expect(Rake::Task['pki:ca:create']).to(receive(:invoke).ordered)
      expect(Rake::Task['pki:crl:generate']).to(receive(:invoke).ordered)
      expect(Rake::Task['pki:dh:generate']).to(receive(:invoke).ordered)

      generate_task.invoke
    end

    it 'allows the CA create task to be overridden' do
      define_task(
          additional_tasks: [
              :initialise,
              {ca: [:build]},
              {crl: [:generate]},
              {dh: [:generate]}
          ]) do |t|
        t.ca_create_task_name = :'ca:build'
      end

      generate_task = Rake::Task['pki:generate']

      expect(Rake::Task['pki:initialise']).to(receive(:invoke).ordered)
      expect(Rake::Task['pki:ca:build']).to(receive(:invoke).ordered)
      expect(Rake::Task['pki:crl:generate']).to(receive(:invoke).ordered)
      expect(Rake::Task['pki:dh:generate']).to(receive(:invoke).ordered)

      generate_task.invoke
    end

    it 'allows the CRL generate task to be overridden' do
      define_task(
          additional_tasks: [
              :initialise,
              {ca: [:create]},
              {crl: [:regenerate]},
              {dh: [:generate]}
          ]) do |t|
        t.crl_generate_task_name = :'crl:regenerate'
      end

      generate_task = Rake::Task['pki:generate']

      expect(Rake::Task['pki:initialise']).to(receive(:invoke).ordered)
      expect(Rake::Task['pki:ca:create']).to(receive(:invoke).ordered)
      expect(Rake::Task['pki:crl:regenerate']).to(receive(:invoke).ordered)
      expect(Rake::Task['pki:dh:generate']).to(receive(:invoke).ordered)

      generate_task.invoke
    end

    it 'allows the DH generate task to be overridden' do
      define_task(
          additional_tasks: [
              :initialise,
              {ca: [:create]},
              {crl: [:generate]},
              {dh: [:initialise]}
          ]) do |t|
        t.dh_generate_task_name = :'dh:initialise'
      end

      generate_task = Rake::Task['pki:generate']

      expect(Rake::Task['pki:initialise']).to(receive(:invoke).ordered)
      expect(Rake::Task['pki:ca:create']).to(receive(:invoke).ordered)
      expect(Rake::Task['pki:crl:generate']).to(receive(:invoke).ordered)
      expect(Rake::Task['pki:dh:initialise']).to(receive(:invoke).ordered)

      generate_task.invoke
    end
  end


  def stub_output
    [:print, :puts].each do |method|
      allow_any_instance_of(Kernel).to(receive(method))
      allow($stdout).to(receive(method))
      allow($stderr).to(receive(method))
    end
  end

  def stub_ruby_easy_rsa
    [
        :init_pki, :build_ca, :gen_dh, :gen_req, :sign_req, :build_client_full,
        :build_server_full, :revoke, :gen_crl, :update_db, :show_req,
        :show_cert, :import_req, :export_p7, :export_p12, :set_rsa_pass,
        :set_ec_pass
    ].each do |method|
      allow(RubyEasyRSA).to(receive(method))
    end
  end
end
