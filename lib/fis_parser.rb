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
      each_line("http://www.fis-ski.com/uk/disciplines/masters/fiscalendar.html?seasoncode_search=#{season}&sector_search=MA&limit=999", 'table[cellpadding="1"] tr') do |index, tds|
        fetch_races season, tds[3].at_css('a')[:href] if index > 0
      end
    end


    def fetch_races season, url
      each_line(url, 'table[bgcolor="#ffffff"] tr') do |index, tds|
        unless index == 0 or tds[2].blank? or tds[8].blank?
          Race.create_or_update_by_codex_and_season(
                  :season => season,
                  :date => d(tds, 1),
                  :codex => i(tds, 2),
                  :place => s(tds, 4),
                  :href => h(tds, 4),
                  :nation => c3(tds, 5),
                  :discipline => s(tds, 6),
                  :gender => s(tds, 7),
                  :category => s(tds, 8),
                  :comments => s(tds, 9)
          )
        end
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
      each_line(race.href, '> table[cellpadding="1"] > *') do |index, tds|
        next if index == 0
        overall_rank = i(tds, 0)
        failure =
                case s(tds, 0)
                  when 'Disqualified' :
                    'DSQ'
                  when 'Did not start' :
                    'DNS'
                  when 'Did not finish' :
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
                    :fis_points => f(tds, 7),
                    :race => race,
                    :competitor => Competitor.create_or_update_by_fis_code(:fis_code => i(tds, 2), :name => s(tds, 3), :href => h(tds, 3), :gender => race.gender, :year => i(tds, 4), :nation => c3(tds, 5))
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
      fetch(url).css("div.contenu #{selector}").each_with_index do |line, index|
        yield(index, (line.name == 'tr' ? line.css('td') : [line]))
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