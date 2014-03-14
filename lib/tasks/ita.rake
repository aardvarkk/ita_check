require 'capybara'
require 'capybara-webkit'
require 'net/http' 
require 'open-uri'
require 'headless'

Rake.application.options.trace = true

LONG_WAIT = 60
SHORT_WAIT = 0

#Capybara.current_driver = :selenium
Capybara.current_driver = :webkit
#Capybara.current_driver = :webkit_debug
# Capybara.javascript_driver = :webkit
Capybara.default_wait_time = LONG_WAIT

# Need to interact with hidden form field
Capybara.ignore_hidden_elements = false

# When searching for an airport showing up on the page, we don't care if it's ambiguous
Capybara.match = :first

# Don't need our own server, I don't think...
Capybara.run_server = false

namespace :ita do
  
  def prices
    @prices ||= []
  end

  def get_itin_str(itin)
    return "#{itin[:oa]} #{itin[:od].strftime('%m/%d/%Y')} -> #{itin[:da]} #{itin[:dd].strftime('%m/%d/%Y')}"
  end

  def test_itin(itin)

    include Capybara::DSL

    itin_str = get_itin_str itin
    puts "Testing itinerary #{itin_str}"

    Capybara.current_session.reset!
    browser = Capybara.current_session.driver.browser

    target = 'http://matrix.itasoftware.com'
    visit target

    fill_in 'advancedfrom1', with: itin[:oa]
    fill_in 'advancedto1', with: itin[:da]
    fill_in 'advanced_rtDeparture', with: itin[:od].strftime('%m/%d/%Y')
    fill_in 'advanced_rtReturn', with: itin[:dd].strftime('%m/%d/%Y')

    click_on 'advanced_searchSubmitButton'

    best_price = find '.itaBestPrice'
    best_price_num = best_price.text.gsub(/\D/,'').to_i

    prices << { itin: itin_str, price: best_price_num }
    puts prices.last

    QueryResult.create(itinerary: itin_str, price: best_price_num, query_id: itin[:id])

    # save_screenshot "#{itin.values.join('_')}.png"

  end

  def run_query(query)

    # oa = query.origins.split(',')
    oa = [query.origins]
    od = parse_dates query.origin_dates
    # da = query.destinations.split(',')
    da = [query.destinations]
    dd = parse_dates query.destination_dates

    puts "Running query: #{oa}-#{da}-#{od}-#{dd}"

    # Set a longer web timeout?
    http = Net::HTTP.new(@host, @port)
    http.read_timeout = LONG_WAIT

    Headless.ly do

      # Here's the massive loop...
      # for all origin airports on all origin dates
      # and all destination airports on all destination dates
      oa.each do |_oa|
        od.each do |_od|
          da.each do |_da|
            dd.each do |_dd|

              puts "Testing #{_oa}-#{_od}-#{_da}-#{_dd}"

              # Get a baseline by testing without the strike
              test_itin oa: _oa, od: _od, da: _da, dd: _dd, id: query.id
            end
          end
        end
      end

      prices.sort_by! { |p| p[:price] }
      puts prices

    end

  end

  def parse_dates(dates)
    dates.split(',').map { |d| Date.parse d }
  end

  desc "Perform all queries in database"
  task query: :environment do
    FILENAME = 'tmp/pids/ita_query.pid'
    if File.exist? FILENAME
      puts "Previous query is still running..."
      next
    end

    pid = File.open FILENAME, 'w'
    pid.puts Process.pid
    pid.close

    # Do work...
    begin
      Query.all.each do |q|
        if !q.active?
          puts "Skipping inactive query #{q.id}"
        else
          run_query q
        end
      end
    rescue
    ensure
      File.delete FILENAME
    end

  end

end
