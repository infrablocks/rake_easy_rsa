require 'spec_helper'
require 'ruby_easy_rsa'

require_relative '../../support/shared_examples/global_parameters'
require_relative '../../support/shared_examples/ssl_parameters'
require_relative '../../support/shared_examples/gitkeep_parameters'

describe RakeEasyRSA::Tasks::Initialise do
  include_context :rake

  before(:each) do
    stub_output
    stub_file_write
    stub_ruby_easy_rsa
  end

  def define_tasks(opts = {}, &block)
    opts = {namespace: :pki}.merge(opts)

    namespace opts[:namespace] do
      subject.define(opts, &block)
    end
  end

  it 'adds a initialise task in the namespace in which it is created' do
    define_tasks

    expect(Rake::Task.task_defined?('pki:initialise'))
        .to(be(true))
  end

  it 'gives the initialise task a description' do
    define_tasks

    expect(Rake::Task['pki:initialise'].full_comment)
        .to(eq('Initialise the PKI working directory'))
  end

  it_behaves_like "a task with global parameters", "pki:initialise"
  it_behaves_like "a task with ssl parameters", "pki:initialise"
  it_behaves_like "a task with gitkeep parameters", "pki:initialise"

  it 'initialises PKI' do
    pki_directory = 'config/secrets/pki'

    expect(RubyEasyRSA)
        .to(receive(:init_pki)
            .with(hash_including(
                pki_directory: pki_directory)))

    define_tasks(
        pki_directory: pki_directory)

    Rake::Task['pki:initialise'].invoke
  end

  it 'writes .gitkeep files by default' do
    pki_directory = 'config/secrets/pki'

    private_directory_gitkeep = double('private')
    req_directory_gitkeep = double('reqs')

    expect(File)
        .to(receive(:open)
            .with('config/secrets/pki/private/.gitkeep', 'w')
            .and_yield(private_directory_gitkeep))
    expect(File)
        .to(receive(:open)
            .with('config/secrets/pki/reqs/.gitkeep', 'w')
            .and_yield(req_directory_gitkeep))
    expect(private_directory_gitkeep)
        .to(receive(:write).with(''))
    expect(req_directory_gitkeep)
        .to(receive(:write).with(''))

    define_tasks(
        pki_directory: pki_directory)

    Rake::Task['pki:initialise'].invoke
  end

  it 'does not write .gitkeep file when requested not to' do
    pki_directory = 'config/secrets/pki'
    include_gitkeep_files = false

    expect(File).not_to(receive(:open))

    define_tasks(
        pki_directory: pki_directory,
        include_gitkeep_files: include_gitkeep_files)

    Rake::Task['pki:initialise'].invoke
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
