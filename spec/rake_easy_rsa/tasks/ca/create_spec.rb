require 'spec_helper'
require 'ruby_easy_rsa'

require_relative '../../../support/shared_examples/global_parameters'
require_relative '../../../support/shared_examples/ssl_parameters'
require_relative '../../../support/shared_examples/algorithm_parameters'
require_relative '../../../support/shared_examples/encrypt_key_parameters'

describe RakeEasyRSA::Tasks::CA::Create do
  include_context :rake

  before(:each) do
    stub_output
    stub_ruby_easy_rsa
  end

  def define_tasks(opts = {}, &block)
    opts = {namespace: :ca}.merge(opts)

    namespace opts[:namespace] do
      subject.define(opts, &block)
    end
  end

  it 'adds a create task in the namespace in which it is created' do
    define_tasks

    expect(Rake::Task.task_defined?('ca:create'))
        .to(be(true))
  end

  it 'gives the create task a description' do
    define_tasks

    expect(Rake::Task['ca:create'].full_comment)
        .to(eq('Create the CA certificate for the PKI'))
  end

  it_behaves_like "a task with global parameters", "ca:create"
  it_behaves_like "a task with ssl parameters", "ca:create"
  it_behaves_like "a task with algorithm parameters", "ca:create"
  it_behaves_like "a task with encrypt key parameters", "ca:create"

  it 'builds a CA' do
    directory = 'config/secrets/pki'

    expect(RubyEasyRSA)
        .to(receive(:build_ca)
            .with(hash_including(
                directory: directory)))

    define_tasks(
        directory: directory)

    Rake::Task['ca:create'].invoke
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
