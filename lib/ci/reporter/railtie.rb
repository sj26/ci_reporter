require "rails"

module CI
  module Reporter
    class Railtie < Rails::Railtie
      config.ci_reporter = ActiveSupport::OrderedOptions.new
      
      # Turn individual reports on or off in rails configuration
      config.ci_reporter.cucumber  = true
      config.ci_reporter.rspec     = true
      config.ci_reporter.test_unit = true
      
      # Customise where all reports go, or just some types of reports
      config.ci_reporter.reports_path = nil
      
      rake_tasks do
        require 'ci/reporter/rake/cucumber'
        require 'ci/reporter/rake/rspec'
        require 'ci/reporter/rake/test_unit'
        
        task "ci:setup:config" do
          # Set CI report output location, unless already set
          ENV["CI_REPORTS"] ||= config.ci_reporter.reports_path
        end
        
        task :cucumber => ["ci:setup:config", "ci:setup:cucumber"] if config.ci_reporter.cucumber
        task :spec     => ["ci:setup:config", "ci:setup:rspec"]    if config.ci_reporter.rspec
        task :test     => ["ci:setup:config", "ci:setup:testunit"] if config.ci_reporter.test_unit
      end
    end
  end
end
