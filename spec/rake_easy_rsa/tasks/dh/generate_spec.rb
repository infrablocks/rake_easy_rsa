# frozen_string_literal: true

require 'spec_helper'
require 'ruby_easy_rsa'

require_relative '../../../support/shared_examples/global_parameters'
require_relative '../../../support/shared_examples/ssl_parameters'
require_relative '../../../support/shared_examples/easy_rsa_ensure_prerequisite'

describe RakeEasyRSA::Tasks::DH::Generate do
  include_context 'rake'

  before do
    stub_output
    stub_ruby_easy_rsa
  end

  def define_tasks(opts = {}, &)
    opts = { namespace: :dh }.merge(opts)

    namespace :easy_rsa do
      task :ensure
    end

    namespace opts[:namespace] do
      subject.define(opts, &)
    end
  end

  it 'adds a generate task in the namespace in which it is created' do
    define_tasks

    expect(Rake.application)
      .to(have_task_defined('dh:generate'))
  end

  it 'gives the generate task a description' do
    define_tasks

    expect(Rake::Task['dh:generate'].full_comment)
      .to(eq('Generate Diffie-Hellman parameters for the PKI'))
  end

  it_behaves_like 'a task with global parameters', 'dh:generate'
  it_behaves_like 'a task with ssl parameters', 'dh:generate'
  it_behaves_like 'a task depending on easy rsa', 'dh:generate'

  it 'generates Diffie-Hellman parameters' do
    pki_directory = 'config/secrets/pki'

    allow(RubyEasyRSA).to(receive(:gen_dh))

    define_tasks(
      pki_directory:
    )

    Rake::Task['dh:generate'].invoke

    expect(RubyEasyRSA)
      .to(have_received(:gen_dh)
            .with(hash_including(
                    pki_directory:
                  )))
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
