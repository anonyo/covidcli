require 'cli/ui'
require 'rest-client'
require 'json'

module Covidcli
  class Process
    BASE_URL = "https://coronavirus-19-api.herokuapp.com/countries"

    def execute
      country = CLI::UI.ask('which country would you like to track covid?')
      CLI::UI::Progress.progress do |bar|
        @response = RestClient.get "#{BASE_URL}/#{country}"
        100.times do
          bar.tick
        end
      end
      body = @response.body
      data = JSON.parse(body) rescue {}
      return CLI::UI::Frame.open("Could not find country #{country}") if data.empty?

      CLI::UI::StdoutRouter.enable
      CLI::UI::Frame.open("Country: #{data["country"]}") do
        CLI::UI::Frame.open('Total number of cases') { puts data["cases"] }
        CLI::UI::Frame.open('Cases today so far') { puts data["todayCases"] }
        CLI::UI::Frame.open('Deaths today so far') { puts data["todayDeaths"] }
        CLI::UI::Frame.open('Deaths total') { puts data["deaths"] }
        CLI::UI::Frame.open('Recovered total') { puts data["recovered"] }
        CLI::UI::Frame.open('Active number of cases') { puts data["active"] }
        CLI::UI::Frame.open('Critical cases') { puts data["critical"] }
      end
    end
  end
end
Covidcli::Process.new.execute
