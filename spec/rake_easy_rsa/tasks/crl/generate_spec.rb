require 'spec_helper'
require 'ruby_easy_rsa'

describe RakeEasyRSA::Tasks::CRL::Generate do
  include_context :rake

  before(:each) do
    stub_output
    stub_ruby_easy_rsa
  end

  def define_task(opts = {}, &block)
    opts = {namespace: :crl}.merge(opts)

    namespace opts[:namespace] do
      subject.define(opts, &block)
    end
  end

  it 'adds a generate task in the namespace in which it is created' do
    define_task

    expect(Rake::Task.task_defined?('crl:generate'))
        .to(be(true))
  end

  it 'gives the generate task a description' do
    define_task

    expect(Rake::Task['crl:generate'].full_comment)
        .to(eq('Generate the certificate revocation list for the PKI'))
  end

  it 'uses the underlying default PKI directory by default' do
    define_task

    rake_task = Rake::Task['crl:generate']
    test_task = rake_task.creator

    expect(test_task.directory).to(be_nil)
  end

  it 'uses the specified PKI directory when provided' do
    directory = 'config/secrets/pki'

    define_task(
        directory: directory)

    rake_task = Rake::Task['crl:generate']
    test_task = rake_task.creator

    expect(test_task.directory).to(eq(directory))
  end

  it 'generates a CRL' do
    directory = 'config/secrets/pki'

    expect(RubyEasyRSA)
        .to(receive(:gen_crl)
            .with(hash_including(
                directory: directory)))

    define_task(
        directory: directory)

    Rake::Task['crl:generate'].invoke
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