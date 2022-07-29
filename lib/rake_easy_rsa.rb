# frozen_string_literal: true

require 'rake_dependencies'
require 'ruby_easy_rsa'
require 'rake_easy_rsa/version'
require 'rake_easy_rsa/tasks'
require 'rake_easy_rsa/task_sets'

module RakeEasyRSA
  def self.define_installation_tasks(opts = {})
    RubyEasyRSA.configure do |c|
      c.binary = File.join(path(opts), 'easyrsa')
    end

    RakeDependencies::TaskSets::All.define(
      installation_task_set_opts(opts)
    )
  end

  def self.define_pki_tasks(opts = {}, &block)
    RakeEasyRSA::TaskSets::PKI.define(opts, &block)
  end

  class << self
    private

    def installation_task_set_opts(opts)
      { namespace: namespace(opts),
        dependency: dependency(opts),
        version: version(opts),
        path: path(opts),
        type: type(opts),
        binary_directory: binary_directory(opts),
        uri_template: uri_template(opts),
        file_name_template: file_name_template(opts),
        strip_path_template: strip_path_template(opts),
        needs_fetch: needs_fetch_check_lambda(opts) }
    end

    def namespace(opts)
      opts[:namespace] || :easy_rsa
    end

    def dependency(_)
      'easy-rsa'
    end

    def version(opts)
      opts[:version] || '3.0.7'
    end

    def path(opts)
      opts[:path] || File.join('vendor', 'easy-rsa')
    end

    def type(_)
      :tgz
    end

    def uri_template(_)
      'https://github.com/OpenVPN/easy-rsa/releases/' \
        'download/v<%= @version %>/' \
        'EasyRSA-<%= @version %>.tgz'
    end

    def binary_directory(_)
      ''
    end

    def file_name_template(_)
      'EasyRSA-<%= @version %>.tgz'
    end

    def strip_path_template(_)
      'EasyRSA-<%= @version %>'
    end

    def needs_fetch_check_lambda(_)
      lambda { |t|
        !File.exist?(File.join(t.path, 'easyrsa'))
      }
    end
  end
end
