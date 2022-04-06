# frozen_string_literal: true

shared_examples 'a task with ssl parameters' do |task_name|
  it 'uses the underlying default expiry by default' do
    define_tasks

    rake_task = Rake::Task[task_name]
    test_task = rake_task.creator

    expect(test_task.expires_in_days).to(be_nil)
  end

  it 'uses the specified expiry when provided' do
    expires_in_days = '90'

    define_tasks(
      expires_in_days: expires_in_days
    )

    rake_task = Rake::Task[task_name]
    test_task = rake_task.creator

    expect(test_task.expires_in_days).to(eq(expires_in_days))
  end

  it 'uses the underlying default digest by default' do
    define_tasks

    rake_task = Rake::Task[task_name]
    test_task = rake_task.creator

    expect(test_task.digest).to(be_nil)
  end

  it 'uses the provided digest when specified' do
    digest = 'sha512'

    define_tasks(
      digest: digest
    )

    rake_task = Rake::Task[task_name]
    test_task = rake_task.creator

    expect(test_task.digest).to(eq(digest))
  end

  it 'uses the underlying default distinguished name mode by default' do
    define_tasks

    rake_task = Rake::Task[task_name]
    test_task = rake_task.creator

    expect(test_task.distinguished_name_mode).to(be_nil)
  end

  it 'uses the provided distinguished name mode when specified' do
    distinguished_name_mode = 'org'

    define_tasks(
      distinguished_name_mode: distinguished_name_mode
    )

    rake_task = Rake::Task[task_name]
    test_task = rake_task.creator

    expect(test_task.distinguished_name_mode).to(eq(distinguished_name_mode))
  end

  it 'uses the underlying default common name by default' do
    define_tasks

    rake_task = Rake::Task[task_name]
    test_task = rake_task.creator

    expect(test_task.common_name).to(be_nil)
  end

  it 'uses the provided common name when specified' do
    common_name = 'server.example.com'

    define_tasks(
      common_name: common_name
    )

    rake_task = Rake::Task[task_name]
    test_task = rake_task.creator

    expect(test_task.common_name).to(eq(common_name))
  end

  it 'uses the underlying default country by default' do
    define_tasks

    rake_task = Rake::Task[task_name]
    test_task = rake_task.creator

    expect(test_task.country).to(be_nil)
  end

  it 'uses the provided country when specified' do
    country = 'GB'

    define_tasks(
      country: country
    )

    rake_task = Rake::Task[task_name]
    test_task = rake_task.creator

    expect(test_task.country).to(eq(country))
  end

  it 'uses the underlying default province by default' do
    define_tasks

    rake_task = Rake::Task[task_name]
    test_task = rake_task.creator

    expect(test_task.province).to(be_nil)
  end

  it 'uses the provided province when specified' do
    province = 'Greater London'

    define_tasks(
      province: province
    )

    rake_task = Rake::Task[task_name]
    test_task = rake_task.creator

    expect(test_task.province).to(eq(province))
  end

  it 'uses the underlying default city by default' do
    define_tasks

    rake_task = Rake::Task[task_name]
    test_task = rake_task.creator

    expect(test_task.city).to(be_nil)
  end

  it 'uses the provided value for city when specified' do
    city = 'London'

    define_tasks(
      city: city
    )

    rake_task = Rake::Task[task_name]
    test_task = rake_task.creator

    expect(test_task.city).to(eq(city))
  end

  it 'uses the underlying default organisation by default' do
    define_tasks

    rake_task = Rake::Task[task_name]
    test_task = rake_task.creator

    expect(test_task.organisation).to(be_nil)
  end

  it 'uses the provided organisation when specified' do
    organisation = 'Company Ltd.'

    define_tasks(
      organisation: organisation
    )

    rake_task = Rake::Task[task_name]
    test_task = rake_task.creator

    expect(test_task.organisation).to(eq(organisation))
  end

  it 'uses the underlying default organisational unit by default' do
    define_tasks

    rake_task = Rake::Task[task_name]
    test_task = rake_task.creator

    expect(test_task.organisational_unit).to(be_nil)
  end

  it 'uses the provided organisational unit when specified' do
    organisational_unit = 'Finance'

    define_tasks(
      organisational_unit: organisational_unit
    )

    rake_task = Rake::Task[task_name]
    test_task = rake_task.creator

    expect(test_task.organisational_unit).to(eq(organisational_unit))
  end

  it 'uses the underlying default email by default' do
    define_tasks

    rake_task = Rake::Task[task_name]
    test_task = rake_task.creator

    expect(test_task.email).to(be_nil)
  end

  it 'uses the provided email when specified' do
    email = 'someone@example.com'

    define_tasks(
      email: email
    )

    rake_task = Rake::Task[task_name]
    test_task = rake_task.creator

    expect(test_task.email).to(eq(email))
  end
end
