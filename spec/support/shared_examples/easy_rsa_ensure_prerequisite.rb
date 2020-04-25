shared_examples "a task depending on easy rsa" do |task_name|
  it 'depends on the easy_rsa:ensure task by default' do
    define_tasks

    expect(Rake::Task[task_name].prerequisite_tasks)
        .to(include(Rake::Task['easy_rsa:ensure']))
  end

  it 'depends on the provided task if specified' do
    namespace :tools do
      namespace :easy_rsa do
        task :ensure
      end
    end

    define_tasks(ensure_task_name: 'tools:easy_rsa:ensure')

    expect(Rake::Task[task_name].prerequisite_tasks)
        .to(include(Rake::Task['tools:easy_rsa:ensure']))
  end
end
