require 'spec_helper'
require 'ruby_easy_rsa'

RSpec.describe RakeEasyRSA do
  it 'has a version number' do
    expect(RakeEasyRSA::VERSION).not_to be nil
  end

  context 'define_installation_tasks' do
    context 'when configuring RubyEasyRSA' do
      it 'sets the binary using a path of vendor/fly by default' do
        RakeEasyRSA.define_installation_tasks

        expect(RubyEasyRSA.configuration.binary)
            .to(eq('vendor/easy-rsa/easyrsa'))
      end

      it 'uses the supplied path when provided' do
        RakeEasyRSA.define_installation_tasks(path: 'tools/easy-rsa')

        expect(RubyEasyRSA.configuration.binary)
            .to(eq('tools/easy-rsa/easyrsa'))
      end
    end

    context 'when instantiating RakeDependencies::Tasks::All' do
      it 'sets the namespace to easy_rsa by default' do
        task_set = RakeEasyRSA.define_installation_tasks

        expect(task_set.namespace).to(eq('easy_rsa'))
      end

      it 'uses the supplied namespace when provided' do
        task_set = RakeEasyRSA.define_installation_tasks(
            namespace: :tools_easy_rsa)

        expect(task_set.namespace).to(eq('tools_easy_rsa'))
      end

      it 'sets the dependency to easy-rsa' do
        task_set = RakeEasyRSA.define_installation_tasks

        expect(task_set.dependency).to(eq('easy-rsa'))
      end

      it 'sets the version to 3.0.7 by default' do
        task_set = RakeEasyRSA.define_installation_tasks

        expect(task_set.version).to(eq('3.0.7'))
      end

      it 'uses the supplied version when provided' do
        task_set = RakeEasyRSA.define_installation_tasks(version: '3.0.7')

        expect(task_set.version).to(eq('3.0.7'))
      end

      it 'uses a path of vendor/easy-rsa by default' do
        task_set = RakeEasyRSA.define_installation_tasks

        expect(task_set.path).to(eq('vendor/easy-rsa'))
      end

      it 'uses the supplied path when provided' do
        task_set = RakeEasyRSA.define_installation_tasks(
            path: File.join('tools', 'easy-rsa'))

        expect(task_set.path).to(eq('tools/easy-rsa'))
      end

      # TODO: test needs_fetch more thoroughly
      it 'provides a needs_fetch checker' do
        task_set = RakeEasyRSA.define_installation_tasks

        expect(task_set.needs_fetch).not_to(be(nil))
      end

      it 'uses a type of tgz' do
        task_set = RakeEasyRSA.define_installation_tasks

        expect(task_set.type).to(eq(:tgz))
      end

      it 'uses an empty binary directory' do
        task_set = RakeEasyRSA.define_installation_tasks

        expect(task_set.binary_directory).to(eq(''))
      end

      it 'uses the correct URI template' do
        task_set = RakeEasyRSA.define_installation_tasks

        expect(task_set.uri_template)
            .to(eq('https://github.com/OpenVPN/easy-rsa/releases/' +
                'download/v<%= @version %>/' +
                'EasyRSA-<%= @version %>.tgz'))
      end

      it 'uses the correct file name template' do
        task_set = RakeEasyRSA.define_installation_tasks

        expect(task_set.file_name_template)
            .to(eq('EasyRSA-<%= @version %>.tgz'))
      end

      it 'uses the correct source binary name template' do
        task_set = RakeEasyRSA.define_installation_tasks

        expect(task_set.strip_path_template)
            .to(eq('EasyRSA-<%= @version %>'))
      end
    end
  end

  context 'define_pki_tasks' do
    context 'when instantiating RakeEasyRSA::TaskSets::PKI' do
      it 'passes the provided block' do
        opts = {
            common_name: 'Some PKI'
        }

        block = lambda do |t|
          t.directory = './secrets/pki'
        end

        expect(RakeEasyRSA::TaskSets::PKI)
            .to(receive(:define) do |passed_opts, &passed_block|
              expect(passed_opts).to(eq(opts))
              expect(passed_block).to(eq(block))
            end)

        RakeEasyRSA.define_pki_tasks(opts, &block)
      end
    end
  end
end
