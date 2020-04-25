require 'spec_helper'
require 'ruby_easy_rsa'

require_relative '../../../support/shared_examples/global_parameters'
require_relative '../../../support/shared_examples/ssl_parameters'
require_relative '../../../support/shared_examples/algorithm_parameters'
require_relative '../../../support/shared_examples/encrypt_key_parameters'
require_relative '../../../support/shared_examples/gitkeep_parameters'
require_relative '../../../support/shared_examples/easy_rsa_ensure_prerequisite'

describe RakeEasyRSA::Tasks::CA::Create do
  include_context :rake

  before(:each) do
    stub_output
    stub_file_write
    stub_ruby_easy_rsa
  end

  def define_tasks(opts = {}, &block)
    opts = {namespace: :ca}.merge(opts)

    namespace :easy_rsa do
      task :ensure
    end

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
  it_behaves_like "a task with gitkeep parameters", "ca:create"
  it_behaves_like "a task depending on easy rsa", "ca:create"

  it 'builds a CA' do
    pki_directory = 'config/secrets/pki'

    expect(RubyEasyRSA)
        .to(receive(:build_ca)
            .with(hash_including(
                pki_directory: pki_directory)))

    define_tasks(
        pki_directory: pki_directory)

    Rake::Task['ca:create'].invoke
  end


  it 'writes .gitkeep files by default' do
    pki_directory = 'config/secrets/pki'

    certs_by_serial_directory_gitkeep = double('certs_by_serial')
    issued_directory_gitkeep = double('reqs')
    renewed_certs_by_serial_directory_gitkeep =
        double('renewed/certs_by_serial')
    renewed_private_by_serial_directory_gitkeep =
        double('renewed/private_by_serial')
    renewed_reqs_by_serial_directory_gitkeep =
        double('renewed/reqs_by_serial')
    revoked_certs_by_serial_directory_gitkeep =
        double('revoked/certs_by_serial')
    revoked_private_by_serial_directory_gitkeep =
        double('revoked/private_by_serial')
    revoked_reqs_by_serial_directory_gitkeep =
        double('revoked/reqs_by_serial')

    expect(File)
        .to(receive(:open)
            .with('config/secrets/pki/certs_by_serial/.gitkeep', 'w')
            .and_yield(certs_by_serial_directory_gitkeep))
    expect(File)
        .to(receive(:open)
            .with('config/secrets/pki/issued/.gitkeep', 'w')
            .and_yield(issued_directory_gitkeep))
    expect(File)
        .to(receive(:open)
            .with('config/secrets/pki/renewed/certs_by_serial/.gitkeep', 'w')
            .and_yield(renewed_certs_by_serial_directory_gitkeep))
    expect(File)
        .to(receive(:open)
            .with('config/secrets/pki/renewed/private_by_serial/.gitkeep', 'w')
            .and_yield(renewed_private_by_serial_directory_gitkeep))
    expect(File)
        .to(receive(:open)
            .with('config/secrets/pki/renewed/reqs_by_serial/.gitkeep', 'w')
            .and_yield(renewed_reqs_by_serial_directory_gitkeep))
    expect(File)
        .to(receive(:open)
            .with('config/secrets/pki/revoked/certs_by_serial/.gitkeep', 'w')
            .and_yield(revoked_certs_by_serial_directory_gitkeep))
    expect(File)
        .to(receive(:open)
            .with('config/secrets/pki/revoked/private_by_serial/.gitkeep', 'w')
            .and_yield(revoked_private_by_serial_directory_gitkeep))
    expect(File)
        .to(receive(:open)
            .with('config/secrets/pki/revoked/reqs_by_serial/.gitkeep', 'w')
            .and_yield(revoked_reqs_by_serial_directory_gitkeep))
    expect(certs_by_serial_directory_gitkeep)
        .to(receive(:write).with(''))
    expect(issued_directory_gitkeep)
        .to(receive(:write).with(''))
    expect(renewed_certs_by_serial_directory_gitkeep)
        .to(receive(:write).with(''))
    expect(renewed_private_by_serial_directory_gitkeep)
        .to(receive(:write).with(''))
    expect(renewed_reqs_by_serial_directory_gitkeep)
        .to(receive(:write).with(''))
    expect(revoked_certs_by_serial_directory_gitkeep)
        .to(receive(:write).with(''))
    expect(revoked_private_by_serial_directory_gitkeep)
        .to(receive(:write).with(''))
    expect(revoked_reqs_by_serial_directory_gitkeep)
        .to(receive(:write).with(''))

    define_tasks(
        pki_directory: pki_directory)

    Rake::Task['ca:create'].invoke
  end

  it 'does not write .gitkeep file when requested not to' do
    pki_directory = 'config/secrets/pki'
    include_gitkeep_files = false

    expect(File).not_to(receive(:open))

    define_tasks(
        pki_directory: pki_directory,
        include_gitkeep_files: include_gitkeep_files)

    Rake::Task['ca:create'].invoke
  end

  def stub_output
    [:print, :puts].each do |method|
      allow_any_instance_of(Kernel).to(receive(method))
      allow($stdout).to(receive(method))
      allow($stderr).to(receive(method))
    end
  end

  def stub_file_write
    file = double('file')
    allow(File).to(receive(:open).and_return(file))
    allow(file).to(receive(:write))
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
