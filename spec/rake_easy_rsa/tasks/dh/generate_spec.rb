require 'spec_helper'
require 'ruby_easy_rsa'

require_relative '../../../support/shared_examples/global_parameters'
require_relative '../../../support/shared_examples/ssl_parameters'

describe RakeEasyRSA::Tasks::DH::Generate do
  include_context :rake

  before(:each) do
    stub_output
    stub_ruby_easy_rsa
  end

  def define_task(opts = {}, &block)
    opts = {namespace: :dh}.merge(opts)

    namespace opts[:namespace] do
      subject.define(opts, &block)
    end
  end

  it 'adds a generate task in the namespace in which it is created' do
    define_task

    expect(Rake::Task.task_defined?('dh:generate'))
        .to(be(true))
  end

  it 'gives the generate task a description' do
    define_task

    expect(Rake::Task['dh:generate'].full_comment)
        .to(eq('Generate Diffie-Hellman parameters for the PKI'))
  end

  it_behaves_like "a task with global parameters", "dh:generate"
  it_behaves_like "a task with ssl parameters", "dh:generate"

  it 'generates Diffie-Hellman parameters' do
    directory = 'config/secrets/pki'

    expect(RubyEasyRSA)
        .to(receive(:gen_dh)
            .with(hash_including(
                directory: directory)))

    define_task(
        directory: directory)

    Rake::Task['dh:generate'].invoke
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
