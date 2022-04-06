# frozen_string_literal: true

require 'spec_helper'
require 'ruby_easy_rsa'

require_relative '../../../support/shared_examples/global_parameters'
require_relative '../../../support/shared_examples/ssl_parameters'
require_relative '../../../support/shared_examples/algorithm_parameters'
require_relative '../../../support/shared_examples/encrypt_key_parameters'
require_relative '../../../support/shared_examples/easy_rsa_ensure_prerequisite'

describe RakeEasyRSA::Tasks::Client::Create do
  include_context 'rake'

  before do
    stub_output
    stub_ruby_easy_rsa
  end

  def define_tasks(opts = {}, &block)
    opts = { namespace: :client }.merge(opts)

    namespace :easy_rsa do
      task :ensure
    end

    namespace opts[:namespace] do
      subject.define(opts, &block)
    end
  end

  it 'adds a create task in the namespace in which it is created' do
    define_tasks

    expect(Rake.application)
      .to(have_task_defined('client:create'))
  end

  it 'gives the create task a description' do
    define_tasks

    expect(Rake::Task['client:create'].full_comment)
      .to(eq('Create a client certificate for the PKI'))
  end

  it_behaves_like 'a task with global parameters', 'client:create'
  it_behaves_like 'a task with ssl parameters', 'client:create'
  it_behaves_like 'a task with algorithm parameters', 'client:create'
  it_behaves_like 'a task with encrypt key parameters', 'client:create'
  it_behaves_like 'a task depending on easy rsa', 'client:create'

  it 'creates a client certificate' do
    pki_directory = 'config/secrets/pki'
    filename_base = 'some_client'

    allow(RubyEasyRSA).to(receive(:build_client_full))

    define_tasks(
      pki_directory: pki_directory
    )

    Rake::Task['client:create'].invoke(filename_base)

    expect(RubyEasyRSA)
      .to(have_received(:build_client_full)
            .with(hash_including(
                    filename_base: filename_base,
                    pki_directory: pki_directory
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
