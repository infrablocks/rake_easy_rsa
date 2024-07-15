# frozen_string_literal: true

require 'spec_helper'
require 'ruby_easy_rsa'

require_relative '../../support/shared_examples/global_parameters'
require_relative '../../support/shared_examples/ssl_parameters'
require_relative '../../support/shared_examples/gitkeep_parameters'
require_relative '../../support/shared_examples/easy_rsa_ensure_prerequisite'

describe RakeEasyRSA::Tasks::Initialise do
  include_context 'rake'

  before do
    stub_output
    stub_file_write
    stub_ruby_easy_rsa
  end

  def define_tasks(opts = {}, &)
    opts = { namespace: :pki }.merge(opts)

    namespace :easy_rsa do
      task :ensure
    end

    namespace opts[:namespace] do
      subject.define(opts, &)
    end
  end

  it 'adds a initialise task in the namespace in which it is created' do
    define_tasks

    expect(Rake.application)
      .to(have_task_defined('pki:initialise'))
  end

  it 'gives the initialise task a description' do
    define_tasks

    expect(Rake::Task['pki:initialise'].full_comment)
      .to(eq('Initialise the PKI working directory'))
  end

  it_behaves_like 'a task with global parameters', 'pki:initialise'
  it_behaves_like 'a task with ssl parameters', 'pki:initialise'
  it_behaves_like 'a task with gitkeep parameters', 'pki:initialise'
  it_behaves_like 'a task depending on easy rsa', 'pki:initialise'

  it 'initialises PKI' do
    pki_directory = 'config/secrets/pki'

    allow(RubyEasyRSA)
      .to(receive(:init_pki))

    define_tasks(
      pki_directory:
    )

    Rake::Task['pki:initialise'].invoke

    expect(RubyEasyRSA)
      .to(have_received(:init_pki)
            .with(hash_including(pki_directory:)))
  end

  # rubocop:disable RSpec/MultipleExpectations
  it 'writes .gitkeep files by default' do
    pki_directory = 'config/secrets/pki'

    allow(File).to(receive(:write))

    define_tasks(
      pki_directory:
    )

    Rake::Task['pki:initialise'].invoke

    expect(File)
      .to(have_received(:write)
            .with('config/secrets/pki/private/.gitkeep', ''))
    expect(File)
      .to(have_received(:write)
            .with('config/secrets/pki/reqs/.gitkeep', ''))
  end
  # rubocop:enable RSpec/MultipleExpectations

  it 'does not write .gitkeep file when requested not to' do
    pki_directory = 'config/secrets/pki'
    include_gitkeep_files = false

    allow(File).to(receive(:open))

    define_tasks(
      pki_directory:,
      include_gitkeep_files:
    )

    Rake::Task['pki:initialise'].invoke

    expect(File).not_to(have_received(:open))
  end

  def stub_output
    %i[print puts].each do |method|
      allow($stdout).to(receive(method))
      allow($stderr).to(receive(method))
    end
  end

  def stub_file_write
    file = instance_double(File)
    allow(File).to(receive(:open).and_return(file))
    allow(file).to(receive(:write))
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
