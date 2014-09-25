namespace :whmcs do

  desc 'Configure environment to use whmcs plugin'
  task :install do
    # copy configuration file template to config directory
    FileUtils.cp(File.expand_path('../config/whmcs.yml', __FILE__), File.expand_path('config', Rails.root))
    puts 'Copied file whmcs.yml to config path'
  end

end