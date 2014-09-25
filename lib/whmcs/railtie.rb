require 'rails'
module Whmcs
  class Railtie < Rails::Railtie
    railtie_name :whmcs

    rake_tasks do
      load 'tasks/whmcs_tasks.rake'
    end
  end
end