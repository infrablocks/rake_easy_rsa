require 'spec_helper'
require 'ruby_easy_rsa'

require_relative '../../../support/shared_examples/global_parameters'

describe RakeEasyRSA::Tasks::Server::Create do
  include_context :rake

  before(:each) do
    stub_output
    stub_ruby_easy_rsa
  end

  def define_task(opts = {}, &block)
    opts = {namespace: :server}.merge(opts)

    namespace opts[:namespace] do
      subject.define(opts, &block)
    end
  end

  it 'adds a create task in the namespace in which it is created' do
    define_task

    expect(Rake::Task.task_defined?('server:create'))
        .to(be(true))
  end

  it 'gives the create task a description' do
    define_task

    expect(Rake::Task['server:create'].full_comment)
        .to(eq('Create a server certificate for the PKI'))
  end

  it_behaves_like "a task with global parameters", "server:create"

  it 'creates a client certificate' do
    directory = 'config/secrets/pki'
    filename_base = 'some_server'

    expect(RubyEasyRSA)
        .to(receive(:build_server_full)
            .with(hash_including(
                filename_base: filename_base,
                directory: directory)))

    define_task(
        directory: directory)

    Rake::Task['server:create'].invoke(filename_base)
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
