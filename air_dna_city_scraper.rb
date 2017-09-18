class AirDnaCityScraper

  attr_accessor :data

  def scrape(city)
    url = "https://www.airdna.co/market-data/app/us/washington/#{normalize_city(city)}/overview"
    driver.navigate.to url

    driver.manage.window.maximize # some bar labels disappear when it is too small

    self.data = {}
    wait.until{
      return nil if driver.find_elements(css:'.custom-modal__title').any?{|x| x.text[/Oops!/]}
      driver.find_elements(css:'.overall-value-occupancy-rate').first.text != '--'
    }

    data[:average_occupancy] = driver.find_elements(css:'.overall-value-occupancy-rate').first.text
    data[:average_daily_rate] = driver.find_elements(css:'.overall-value-pricing').first.text
    data[:average_revenue] = driver.find_elements(css:'.overall-value-revenue').first.text
    data[:demand] = driver.find_elements(css:'.market-health-section__right-axis-text').first.text
    data[:active_rentals] = driver.find_elements(css:'.overview-page__left-side section').first.find_elements(css:'.section__header').first.text.split.first
    data[:entire_home_share] = driver.find_elements(css:'.overview-page__left-side section').first.find_elements(css:'.section__title span').second.text.split.first

    bars = []
    wait.until{
      bars = driver.find_elements(css:'.overview-page__left-side section').second.find_elements(css:'.bar-chart .bar')
      bars.present?
    }
    bar_labels = driver.find_elements(css:'.overview-page__left-side section').second.find_elements(css:'.bar-chart .axis--x .tick').map(&:text)

    bar_labels.each_with_index do |label,i|
      type_label = "size_#{label}_room".to_sym
      store_room_size_tooltip_data(bars[i],as:type_label)
    end

    # driver.action.move_to(bars.first).perform
    # data[:size_studio] = parse_rental_size_tooltip displayed_tooltips(driver).first

    # driver.action.move_to(bars[1]).perform
    # data[:size_1_room] = parse_rental_size_tooltip displayed_tooltips(driver).first

    # driver.action.move_to(bars[2]).perform
    # data[:size_2_room] = parse_rental_size_tooltip displayed_tooltips(driver).first

    # driver.action.move_to(bars[3]).perform
    # data[:size_3_room] = parse_rental_size_tooltip displayed_tooltips(driver).first

    AirDnaCity.new(city, data)
  rescue Net::ReadTimeout => e
binding.pry
  rescue =>e
    warn e
    puts 'city: ' + city
    nil
  end

  def normalize_city(city)
    city.to_s.underscore.parameterize.dasherize
  end

  def driver
    @driver ||= Selenium::WebDriver.for :firefox
  end

  def parse_rental_size_tooltip(text)
    text.split.instance_eval{|a| {count:a[1],share:a[2].gsub(/[\(\)]/,'')}}
  end

  def displayed_tooltips(driver)
    driver.find_elements(css:'.toolTip').map(&:text).reject(&:blank?)
  end

  def store_room_size_tooltip_data(el,as:)
    scroll_to_element(el)
    driver.action.move_to(el).perform
    data[as] = parse_rental_size_tooltip displayed_tooltips(driver).first
  end

  def scroll_to_element(el)
    el.location_once_scrolled_into_view
  end

  def wait
    Selenium::WebDriver::Wait.new(timeout: 5)
  end
end