# frozen_string_literal: true

require 'spec_helper'
require 'ruby_easy_rsa'

require_relative '../../../support/shared_examples/global_parameters'
require_relative '../../../support/shared_examples/ssl_parameters'
require_relative '../../../support/shared_examples/algorithm_parameters'
require_relative '../../../support/shared_examples/encrypt_key_parameters'
require_relative '../../../support/shared_examples/gitkeep_parameters'
require_relative '../../../support/shared_examples/easy_rsa_ensure_prerequisite'

describe RakeEasyRSA::Tasks::CA::Create do
  include_context 'rake'

  before do
    stub_output
    stub_file_write
    stub_ruby_easy_rsa
  end

  def define_tasks(opts = {}, &block)
    opts = { namespace: :ca }.merge(opts)

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
      .to(have_task_defined('ca:create'))
  end

  it 'gives the create task a description' do
    define_tasks

    expect(Rake::Task['ca:create'].full_comment)
      .to(eq('Create the CA certificate for the PKI'))
  end

  it_behaves_like 'a task with global parameters', 'ca:create'
  it_behaves_like 'a task with ssl parameters', 'ca:create'
  it_behaves_like 'a task with algorithm parameters', 'ca:create'
  it_behaves_like 'a task with encrypt key parameters', 'ca:create'
  it_behaves_like 'a task with gitkeep parameters', 'ca:create'
  it_behaves_like 'a task depending on easy rsa', 'ca:create'

  it 'builds a CA' do
    pki_directory = 'config/secrets/pki'

    allow(RubyEasyRSA)
      .to(receive(:build_ca))

    define_tasks(
      pki_directory: pki_directory
    )

    Rake::Task['ca:create'].invoke

    expect(RubyEasyRSA)
      .to(have_received(:build_ca)
            .with(hash_including(
                    pki_directory: pki_directory
                  )))
  end

  # rubocop:disable RSpec/MultipleExpectations
  it 'writes .gitkeep files by default' do
    pki_directory = 'config/secrets/pki'

    allow(File).to(receive(:write))

    define_tasks(
      pki_directory: pki_directory
    )

    Rake::Task['ca:create'].invoke

    expect(File)
      .to(have_received(:write)
            .with('config/secrets/pki/certs_by_serial/.gitkeep', ''))
    expect(File)
      .to(have_received(:write)
            .with('config/secrets/pki/issued/.gitkeep', ''))
    expect(File)
      .to(have_received(:write)
            .with('config/secrets/pki/renewed/certs_by_serial/.gitkeep', ''))
    expect(File)
      .to(have_received(:write)
            .with('config/secrets/pki/renewed/private_by_serial/.gitkeep', ''))
    expect(File)
      .to(have_received(:write)
            .with('config/secrets/pki/renewed/reqs_by_serial/.gitkeep', ''))
    expect(File)
      .to(have_received(:write)
            .with('config/secrets/pki/revoked/certs_by_serial/.gitkeep', ''))
    expect(File)
      .to(have_received(:write)
            .with('config/secrets/pki/revoked/private_by_serial/.gitkeep', ''))
    expect(File)
      .to(have_received(:write)
            .with('config/secrets/pki/revoked/reqs_by_serial/.gitkeep', ''))
  end
  # rubocop:enable RSpec/MultipleExpectations

  it 'does not write .gitkeep file when requested not to' do
    pki_directory = 'config/secrets/pki'
    include_gitkeep_files = false

    allow(File).to(receive(:write))

    define_tasks(
      pki_directory: pki_directory,
      include_gitkeep_files: include_gitkeep_files
    )

    Rake::Task['ca:create'].invoke

    expect(File).not_to(have_received(:write))
  end

  def stub_output
    %i[print puts].each do |method|
      allow($stdout).to(receive(method))
      allow($stderr).to(receive(method))
    end
  end

  def stub_file_write
    allow(File).to(receive(:write))
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
