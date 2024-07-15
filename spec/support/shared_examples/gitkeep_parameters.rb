# frozen_string_literal: true

shared_examples 'a task with gitkeep parameters' do |task_name|
  it 'includes gitkeep files by default' do
    define_tasks

    rake_task = Rake::Task[task_name]
    test_task = rake_task.creator

    expect(test_task.include_gitkeep_files).to(be(true))
  end

  it 'uses the specified value for include gitkeep files when provided' do
    include_gitkeep_files = false

    define_tasks(
      include_gitkeep_files:
    )

    rake_task = Rake::Task[task_name]
    test_task = rake_task.creator

    expect(test_task.include_gitkeep_files).to(eq(include_gitkeep_files))
  end
end
