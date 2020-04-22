require 'rake_dependencies'
require 'ruby_easy_rsa'
require 'rake_easy_rsa/version'
require 'rake_easy_rsa/tasks'

module RakeEasyRSA
  def self.define_installation_tasks(opts = {})
    namespace = opts[:namespace] || :easy_rsa
    version = opts[:version] || '3.0.7'
    path = opts[:path] || File.join('vendor', 'easy-rsa')
    type = :tgz
    binary_directory = ''
    uri_template = 'https://github.com/OpenVPN/easy-rsa/releases/' +
        'download/v<%= @version %>/' +
        'EasyRSA-<%= @version %>.tgz'
    file_name_template = 'EasyRSA-<%= @version %>.tgz'
    strip_path_template = 'EasyRSA-<%= @version %>'

    task_set_opts = {
        namespace: namespace,
        dependency: 'easy-rsa',
        version: version,
        path: path,
        type: type,
        binary_directory: binary_directory,
        uri_template: uri_template,
        file_name_template: file_name_template,
        strip_path_template: strip_path_template,
        needs_fetch: lambda { |t|
          !File.exist?(File.join(t.path, 'easyrsa'))
        }}

    RubyEasyRSA.configure do |c|
      c.binary = File.join(path, 'easyrsa')
    end

    RakeDependencies::TaskSets::All.define(task_set_opts)
  end
end