require 'rake_factory'
require 'ruby_easy_rsa'

module RakeEasyRSA
  module Tasks
    class Generate < RakeFactory::Task
      default_name :generate
      default_description "Generate all pre-requisites for managing the PKI"

      parameter :initialise_task_name, default: 'initialise'
      parameter :ca_create_task_name, default: 'ca:create'
      parameter :crl_generate_task_name, default: 'crl:generate'
      parameter :dh_generate_task_name, default: 'dh:generate'

      action do |t, args|
        puts "Generating PKI pre-requisites... "
        t.application[t.initialise_task_name, t.scope].invoke(*args)
        t.application[t.ca_create_task_name, t.scope].invoke(*args)
        t.application[t.crl_generate_task_name, t.scope].invoke(*args)
        t.application[t.dh_generate_task_name, t.scope].invoke(*args)
        puts "Done."
      end
    end
  end
end
