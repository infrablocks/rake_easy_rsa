require 'spec_helper'
require 'ruby_easy_rsa'

describe RakeEasyRSA::Tasks::Initialise do
  include_context :rake

  before(:each) do
    stub_output
  end

  def define_task(opts = {}, &block)
    opts = {namespace: :pki}.merge(opts)

    namespace opts[:namespace] do
      subject.define(opts, &block)
    end
  end

  it 'adds a initialise task in the namespace in which it is created' do
    define_task

    expect(Rake::Task.task_defined?('pki:initialise'))
        .to(be(true))
  end

  it 'gives the initialise task a description' do
    define_task

    expect(Rake::Task['pki:initialise'].full_comment)
        .to(eq('Initialise the PKI working directory'))
  end

  it 'has uses the underlying default PKI directory by default' do
    define_task

    rake_task = Rake::Task['pki:initialise']
    test_task = rake_task.creator

    expect(test_task.directory).to(be_nil)
  end

  it 'uses the specified PKI directory when provided' do
    directory = 'config/secrets/pki'

    define_task(
        directory: directory)

    rake_task = Rake::Task['pki:initialise']
    test_task = rake_task.creator

    expect(test_task.directory).to(eq(directory))
  end

  it 'initialises PKI' do
    directory = 'config/secrets/pki'

    expect(RubyEasyRSA)
        .to(receive(:init_pki)
            .with(hash_including(
                directory: directory)))

    define_task(
        directory: directory)

    Rake::Task['pki:initialise'].invoke
  end

  def stub_output
    [:print, :puts].each do |method|
      allow_any_instance_of(Kernel).to(receive(method))
      allow($stdout).to(receive(method))
      allow($stderr).to(receive(method))
    end
  end
end
