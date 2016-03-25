require 'nokogiri'
require 'open-uri'

class FisParser
  class << self
    def load_seasons(seasons)
      seasons.each { |s| load_season s }
    end

    def load_season season
      fetch_events season
      update_races season
      Race.update_factors season
    end

    private
    def fetch_events season
      each_line("http://data.fis-ski.com/masters/home.html?seasoncode_search=#{season}&sector_search=MA&limit=999", 'tr[data-line]') do |index, tds|
        fetch_races season, tds[2].at_css('a')[:href]
      end
    end


    HEADER_SELECTOR = '.footable > thead > tr > th'
    DATA_SELECTOR = '.footable > tbody > tr:not(.tr-sep)'

    def fetch_races season, url
      each_line(url, DATA_SELECTOR) do |index, tds|
        codex = i(tds, 4)
        hash = {:date => d(tds, 1),
                :place => tds[2].at_css('span').text,
                :href => h(tds, 4),
                :nation => c3(tds, 3),
                :discipline => s(tds, 5),
                :gender => s(tds, 6),
                :category => s(tds, 7),
                :comments => s(tds, 8)}
        create_or_update(Race, {:season => season, :codex => codex}, hash) unless hash[:category].blank? or codex.nil?
      end
    end

    def update_races(season)
      Race.to_be_scored(season).where("href is not null and date < ?", Time.now + 1.week).each do |race|
        if fetch_results(race) and year=race.results.first.competitor.year
          race.update_attribute(:status, 'loaded')
          race.update_attribute(:loaded_at, Time.now)
          race.update_attribute(:age_group, AgeClass.new(:season => race.season, :year => year, gender: race.gender).age_group)
        end
      end
    end

    def fetch_results race
      loaded = false
      failure = nil
      winners_time = nil
      content = fetch("#{race.href}&catage=all")
      headers = content.css(HEADER_SELECTOR).each_with_index.map { |s, index| [s.text, index] }.to_h
      each_content_line(content, DATA_SELECTOR) do |index, tds|
        failure =
            case s(tds, 0)
              when 'Disqualified'
                'DSQ'
              when 'Did not start'
                'DNS'
              when 'Did not finish'
                'DNF'
              else
                failure
            end
        next if tds.length < 6
        result = load_result(race, failure, tds, headers)
        winners_time ||= result.time
        if result.time && !result.race_points
          f_factor ||= Rules::FFactorRule.f_factor(race)
          result.update_attribute :race_points, ((result.time/winners_time-1)*f_factor).round(2)
        end
        loaded = true
      end
      loaded
    end

    def load_result(race, failure, tds, headers)
      Result.create failure: failure,
                    time: time(tds, headers['Total Time']),
                    race_points: f(tds, headers['FIS Points']),
                    race: race,
                    competitor: create_or_update(Competitor, {fis_code: i(tds, 2)}, name: s(tds, 3), href: h(tds, 3), gender: race.gender, year: i(tds, 4), nation: c3(tds, 5))
    end

    def create_or_update klass, keys, attributes
      object = klass.find_by(keys)
      object.update!(attributes) if object
      object || klass.create!(keys.merge attributes)
    end

    def num tds, index
      s(tds, index)[/[0-9\.]+/] if numeric? tds, index
    end

    def i td, index
      num(td, index).try :to_i
    end

    def f td, index
      num(td, index).try :to_f
    end

    def s td, i
      td[i].try :text if i
    end

    def d td, i
      Date.strptime(td[i].text, "%d.%m.%Y")
    end

    def c3 td, i
      s(td, i)[0, 3]
    end

    def h td, i
      (link = td[i].at_css('a')) and link[:href]
    end

    def time td, i
      to_time s(td, i).scan(/[0-9:.,]+/).first
    end

    def to_time s
      s && s.sub(',', '.').split(':').reduce(0) { |s, v| 60*s+v.to_f }
    end

    def numeric? tds, i
      s(tds, i) =~ /[0-9\.]+/
    end

    def each_line(url, selector, &block)
      each_content_line(fetch(url), selector, &block)
    end

    def each_content_line(content, selector)
      content.css(selector).each_with_index do |line, index|
        yield(index, (line.name == 'tr' ? line.css('>td') : [line]))
      end
    end

    def fetch url
      start = Time.new
      puts "Fetching #{url}"
      doc = Nokogiri::HTML(open(url))
      puts "Done in #{Time.new - start}"
      doc
    end
  end
end