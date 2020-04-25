require 'spec_helper'
require 'ruby_easy_rsa'

require_relative '../../../support/shared_examples/global_parameters'
require_relative '../../../support/shared_examples/ssl_parameters'
require_relative '../../../support/shared_examples/encrypt_key_parameters'

describe RakeEasyRSA::Tasks::Certificate::Renew do
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

  it 'adds a renew task in the namespace in which it is created' do
    define_tasks

    expect(Rake::Task.task_defined?('certificate:renew'))
        .to(be(true))
  end

  it 'gives the renew task a description' do
    define_tasks

    expect(Rake::Task['certificate:renew'].full_comment)
        .to(eq('Renew a certificate of the PKI'))
  end

  it_behaves_like "a task with global parameters", "certificate:renew"
  it_behaves_like "a task with ssl parameters", "certificate:renew"
  it_behaves_like "a task with encrypt key parameters", "certificate:renew"

  it 'renews a certificate' do
    pki_directory = 'config/secrets/pki'
    filename_base = 'some_client'

    expect(RubyEasyRSA)
        .to(receive(:renew)
            .with(hash_including(
                filename_base: filename_base,
                pki_directory: pki_directory)))

    define_tasks(
        pki_directory: pki_directory)

    Rake::Task['certificate:renew'].invoke(filename_base)
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
