require 'nokogiri'
require 'open-uri'

class FisParser
  class << self
    def update_events season
      ActiveRecord::Base.transaction do
        fetch("http://www.fis-ski.com/uk/disciplines/masters/fiscalendar.html?seasoncode_search=#{season}&sector_search=MA&category_search=FMC&limit=999").css('div.contenu table[cellpadding="1"] tr').each_with_index do |line, index|
          if index > 0
            update_races season, line.css('td')[3].at_css('a')[:href]
          end
        end
      end
    end

    def parse_results race
      racers = 0
      fetch(race.href).css('div.contenu > table[cellpadding="1"] tr').each_with_index do |line, index|
        result = line.css('td')
        if index != 0  and s(result, 0) =~ /[0-9]+/
          load_result(race, result)
          racers+=1
        end
      end
      racers
    end

    private
    def update_races season, url
      fetch(url).css('div.contenu table[bgcolor="#ffffff"] tr').each_with_index do |line, index|
        td = line.css('td')
        comp_cat = s(td, 8)
        if index > 0 and fmc_race comp_cat
          Race.create_or_update_by_codex_and_season(
                  :season => season,
                  :date => d(td, 1),
                  :codex => i(td, 2),
                  :place => s(td, 4),
                  :href => h(td, 4),
                  :nation => c3(td, 5),
                  :discipline => s(td, 6),
                  :gender => s(td, 7),
                  :comments => s(td, 9)
          )
        end
      end
    end

    def fmc_race comp_cat
      ['FMC', 'WCM'].include? comp_cat
    end

    def load_result(race, td)
      Result.create :overall_rank => i(td, 0),
                    :fis_points => f(td, 7),
                    :race => race,
                    :competitor => Competitor.create_or_update_by_fis_code(:fis_code => i(td, 2), :name => s(td, 3), :href => h(td, 3), :gender => race.gender, :year => i(td, 4), :nation => c3(td, 5))
    end

    def num result, index
      result[index].text[/[0-9\.]+/]
    end

    def i td, index
      num(td, index).to_i
    end

    def f td, index
      num(td, index).to_f
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

    def fetch url
      start = Time.new
      puts "Fetching #{url}"
      doc = Nokogiri::HTML(open(url))
      puts "Done in #{Time.new - start}"
      doc
    end
  end
end