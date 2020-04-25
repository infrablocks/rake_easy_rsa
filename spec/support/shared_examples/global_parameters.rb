shared_examples "a task with global parameters" do |task_name|
  it 'uses a PKI directory of ./pki by default' do
    define_tasks

    rake_task = Rake::Task[task_name]
    test_task = rake_task.creator

    expect(test_task.pki_directory).to(eq('./pki'))
  end

  it 'uses the specified PKI directory when provided' do
    pki_directory = 'config/secrets/pki'

    define_tasks(
        pki_directory: pki_directory)

    rake_task = Rake::Task[task_name]
    test_task = rake_task.creator

    expect(test_task.pki_directory).to(eq(pki_directory))
  end

  it 'uses the underlying default extensions directory by default' do
    define_tasks

    rake_task = Rake::Task[task_name]
    test_task = rake_task.creator

    expect(test_task.extensions_directory).to(be_nil)
  end

  it 'uses the provided extensions directory when specified' do
    extensions_directory = './pki/extensions'

    define_tasks(
        extensions_directory: extensions_directory)

    rake_task = Rake::Task[task_name]
    test_task = rake_task.creator

    expect(test_task.extensions_directory).to(eq(extensions_directory))
  end

  it 'uses the underlying default openssl binary by default' do
    define_tasks

    rake_task = Rake::Task[task_name]
    test_task = rake_task.creator

    expect(test_task.openssl_binary).to(be_nil)
  end

  it 'uses the provided openssl binary when specified' do
    openssl_binary = "./vendor/openssl/bin/openssl"

    define_tasks(
        openssl_binary: openssl_binary)

    rake_task = Rake::Task[task_name]
    test_task = rake_task.creator

    expect(test_task.openssl_binary).to(eq(openssl_binary))
  end

  it 'uses the underlying default ssl configuration by default' do
    define_tasks

    rake_task = Rake::Task[task_name]
    test_task = rake_task.creator

    expect(test_task.ssl_configuration).to(be_nil)
  end

  it 'uses the provided ssl configuration when specified' do
    ssl_configuration = "./vendor/easyrsa/openssl-easyrsa.cnf"

    define_tasks(
        ssl_configuration: ssl_configuration)

    rake_task = Rake::Task[task_name]
    test_task = rake_task.creator

    expect(test_task.ssl_configuration).to(eq(ssl_configuration))
  end

  it 'uses the underlying default safe configuration by default' do
    define_tasks

    rake_task = Rake::Task[task_name]
    test_task = rake_task.creator

    expect(test_task.safe_configuration).to(be_nil)
  end

  it 'uses the provided safe configuration when specified' do
    safe_configuration = "./vendor/easyrsa/safessl-easyrsa.cnf"

    define_tasks(
        safe_configuration: safe_configuration)

    rake_task = Rake::Task[task_name]
    test_task = rake_task.creator

    expect(test_task.safe_configuration).to(eq(safe_configuration))
  end

  it 'uses the underlying default vars by default' do
    define_tasks

    rake_task = Rake::Task[task_name]
    test_task = rake_task.creator

    expect(test_task.vars).to(be_nil)
  end

  it 'uses the provided vars when specified' do
    vars = "./pki/vars"

    define_tasks(
        vars: vars)

    rake_task = Rake::Task[task_name]
    test_task = rake_task.creator

    expect(test_task.vars).to(eq(vars))
  end

  it 'uses batch by default' do
    define_tasks

    rake_task = Rake::Task[task_name]
    test_task = rake_task.creator

    expect(test_task.batch).to(be(true))
  end

  it 'uses the provided value for batch when specified' do
    batch = false

    define_tasks(
        batch: batch)

    rake_task = Rake::Task[task_name]
    test_task = rake_task.creator

    expect(test_task.batch).to(eq(batch))
  end

  it 'uses the underlying default input password by default' do
    define_tasks

    rake_task = Rake::Task[task_name]
    test_task = rake_task.creator

    expect(test_task.input_password).to(be_nil)
  end

  it 'uses the provided input password when specified' do
    input_password = 'pass:1234'

    define_tasks(
        input_password: input_password)

    rake_task = Rake::Task[task_name]
    test_task = rake_task.creator

    expect(test_task.input_password).to(eq(input_password))
  end

  it 'uses the underlying default output password by default' do
    define_tasks

    rake_task = Rake::Task[task_name]
    test_task = rake_task.creator

    expect(test_task.output_password).to(be_nil)
  end

  it 'uses the provided output password when specified' do
    output_password = 'pass:1234'

    define_tasks(
        output_password: output_password)

    rake_task = Rake::Task[task_name]
    test_task = rake_task.creator

    expect(test_task.output_password).to(eq(output_password))
  end
end
