# frozen_string_literal: true

shared_examples 'a task with algorithm parameters' do |task_name|
  it 'uses the underlying default algorithm by default' do
    define_tasks

    rake_task = Rake::Task[task_name]
    test_task = rake_task.creator

    expect(test_task.algorithm).to(be_nil)
  end

  it 'uses the specified algorithm when provided' do
    algorithm = 'ec'

    define_tasks(
      algorithm:
    )

    rake_task = Rake::Task[task_name]
    test_task = rake_task.creator

    expect(test_task.algorithm).to(eq(algorithm))
  end

  it 'uses the underlying default curve by default' do
    define_tasks

    rake_task = Rake::Task[task_name]
    test_task = rake_task.creator

    expect(test_task.curve).to(be_nil)
  end

  it 'uses the provided curve when specified' do
    curve = 'sect571k1'

    define_tasks(
      curve:
    )

    rake_task = Rake::Task[task_name]
    test_task = rake_task.creator

    expect(test_task.curve).to(eq(curve))
  end

  it 'uses the underlying default EC directory by default' do
    define_tasks

    rake_task = Rake::Task[task_name]
    test_task = rake_task.creator

    expect(test_task.ec_directory).to(be_nil)
  end

  it 'uses the provided EC directory when specified' do
    ec_directory = './ec'

    define_tasks(
      ec_directory:
    )

    rake_task = Rake::Task[task_name]
    test_task = rake_task.creator

    expect(test_task.ec_directory).to(eq(ec_directory))
  end
end
