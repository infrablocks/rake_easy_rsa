require 'spec_helper'
require 'ruby_easy_rsa'

require_relative '../../../support/shared_examples/global_parameters'
require_relative '../../../support/shared_examples/ssl_parameters'

describe RakeEasyRSA::Tasks::Certificate::Revoke do
  include_context :rake

  before(:each) do
    stub_output
    stub_ruby_easy_rsa
  end

  def define_tasks(opts = {}, &block)
    opts = {namespace: :certificate}.merge(opts)

    namespace opts[:namespace] do
      subject.define(opts, &block)
    end
  end

  it 'adds a revoke task in the namespace in which it is created' do
    define_tasks

    expect(Rake::Task.task_defined?('certificate:revoke'))
        .to(be(true))
  end

  it 'gives the revoke task a description' do
    define_tasks

    expect(Rake::Task['certificate:revoke'].full_comment)
        .to(eq('Revoke a certificate of the PKI'))
  end

  it 'uses a reason of unspecified by default' do
    define_tasks

    rake_task = Rake::Task['certificate:revoke']
    test_task = rake_task.creator

    expect(test_task.reason).to(eq('unspecified'))
  end

  it 'uses the specified reason when provided' do
    reason = "affiliationChanged"

    define_tasks(
        reason: reason)

    rake_task = Rake::Task['certificate:revoke']
    test_task = rake_task.creator

    expect(test_task.reason).to(eq(reason))
  end

  it_behaves_like "a task with global parameters", "certificate:revoke"
  it_behaves_like "a task with ssl parameters", "certificate:revoke"

  it 'revokes a certificate' do
    pki_directory = 'config/secrets/pki'
    filename_base = 'some_client'

    expect(RubyEasyRSA)
        .to(receive(:revoke)
            .with(hash_including(
                filename_base: filename_base,
                pki_directory: pki_directory)))

    define_tasks(
        pki_directory: pki_directory)

    Rake::Task['certificate:revoke'].invoke(filename_base)
  end

  it 'accepts a reason as an optional argument' do
    pki_directory = 'config/secrets/pki'
    filename_base = 'some_client'
    reason = "CACompromise"

    expect(RubyEasyRSA)
        .to(receive(:revoke)
            .with(hash_including(
                filename_base: filename_base,
                pki_directory: pki_directory,
                reason: reason)))

    define_tasks(
        pki_directory: pki_directory)

    Rake::Task['certificate:revoke'].invoke(filename_base, reason)
  end

  it 'uses the reason parameter value by default' do
    pki_directory = 'config/secrets/pki'
    filename_base = 'some_client'
    reason = "affiliationChanged"

    expect(RubyEasyRSA)
        .to(receive(:revoke)
            .with(hash_including(
                filename_base: filename_base,
                pki_directory: pki_directory,
                reason: reason)))

    define_tasks(
        pki_directory: pki_directory,
        reason: reason)

    Rake::Task['certificate:revoke'].invoke(filename_base)
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
