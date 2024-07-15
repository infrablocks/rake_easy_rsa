# frozen_string_literal: true

shared_examples 'a task with encrypt key parameters' do |task_name|
  it 'uses does not encrypt key by default' do
    define_tasks

    rake_task = Rake::Task[task_name]
    test_task = rake_task.creator

    expect(test_task.encrypt_key).to(be(false))
  end

  it 'uses the specified value for encrypt key when provided' do
    encrypt_key = true

    define_tasks(
      encrypt_key:
    )

    rake_task = Rake::Task[task_name]
    test_task = rake_task.creator

    expect(test_task.encrypt_key).to(eq(encrypt_key))
  end
end
