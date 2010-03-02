require 'nokogiri'
require 'open-uri'

class FisParser
  class << self
    def parse_events
      ActiveRecord::Base.transaction do
        Competitor.delete_all
        fetch("http://www.fis-ski.com/uk/disciplines/masters/results.html").css('div.contenu table[cellpadding="1"] tr').each_with_index do |line, index|
          details = line.css('td')
          comp_cat = details[5].text
          if index > 0 and potential_fmc_race comp_cat
            parse_races details[3].at_css('a')[:href]
          end
        end
      end
    end

    private
    def parse_races url
      fetch(url).css('div.contenu table[bgcolor="#ffffff"] tr').each_with_index do |line, index|
        details = line.css('td')
        gender = details[7].text
        comp_cat = details[8].text
        if index > 0 and fmc_race comp_cat
          link = details[4].at_css('a')
          (1..13).each {|cat| break unless parse_result(link[:href]+"&catage=#{cat+5}", cat, gender)} if link
        end
      end
    end

    def potential_fmc_race comp_cat
      not ['MAS', 'SAC'].include? comp_cat
    end

    def fmc_race comp_cat
      ['FMC', 'WCM']
    end

    def parse_result url, cat, gender
      fetch(url).css('div.contenu > table[cellpadding="1"] tr').each_with_index do |line, index|
        result = line.css('td')
        if index == 0
          return false unless result[8] and result[8].text == 'Cup Points'
        else
          if result[0].text =~ /[0-9]+/
            add_result(url, result, gender, cat)
          end
        end
      end
      true
    end

    def add_result(url, result, gender, cat)
      fis_code = num(result, 2).to_i
      name = result[3].at_css('a')
      competitor = Competitor.find_all_by_fis_code(fis_code).first ||
              Competitor.create(:fis_code => fis_code, :name => name.text, :href => name[:href], :year => num(result, 4).to_i, :nation => result[5].text[0,3], :gender => gender, :category => cat)
      competitor.results << Result.create(:rank => num(result, 0).to_i, :fis_points => num(result, 7).to_f, :cup_points => num(result, 8).to_f, :href => url)
    end

    def num result, index
      result[index].text[/[0-9\.]+/]
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