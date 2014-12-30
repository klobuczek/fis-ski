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
          race.update_attribute(:age_group, AgeClass.new(:season => race.season, :year => year).age_group(race.gender))
          race.update_age_class_ranks
        end
      end
    end

    def fetch_results race
      loaded = false
      failure = nil
      each_line(race.href, DATA_SELECTOR) do |index, tds|
        overall_rank = i(tds, 0)
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
        load_result(race, overall_rank, failure, tds)
        loaded = true
      end
      loaded
    end

    def load_result(race, overall_rank, failure, tds)
      Result.create :overall_rank => overall_rank,
                    :failure => failure,
                    :fis_points => f(tds, 8),
                    :race => race,
                    :competitor => create_or_update(Competitor, {:fis_code => i(tds, 2)}, :name => s(tds, 3), :href => h(tds, 3), :gender => race.gender, :year => i(tds, 4), :nation => c3(tds, 5))
    end

    def create_or_update klass, keys, attributes
      object = klass.find_by(keys)
      object.update!(attributes) if object
      object || klass.create!(keys.merge attributes)
    end

    def num tds, index
      tds[index].text[/[0-9\.]+/] if numeric? tds, index
    end

    def i td, index
      num(td, index).try :to_i
    end

    def f td, index
      num(td, index).try :to_f
    end

    def s td, i
      td[i].text
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

    def numeric? tds, i
      s(tds, i) =~ /[0-9\.]+/
    end

    def each_line(url, selector)
      # fetch(url).css("div.contenu #{selector}").each_with_index do |line, index|
      fetch(url).css(selector).each_with_index do |line, index|
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