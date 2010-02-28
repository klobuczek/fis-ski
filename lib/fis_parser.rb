require 'nokogiri'
require 'open-uri'

class FisParser
#require 'rubygems'

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

  def initialize
    @competitors = {}
  end

  def parse_events gender, cat
    url = "http://www.fis-ski.com/uk/disciplines/masters/results.html"
    doc = Nokogiri::HTML(open(url))
    doc.css('div.contenu table[cellpadding="1"] tr').each_with_index do |line, index|
      details = line.css('td')
      if index > 0
        parse_races details[3].at_css('a')[:href], gender, cat
      end
    end
  end

  def parse_races url, gender, cat
    doc = Nokogiri::HTML(open(url))
    doc.css('div.contenu table[bgcolor="#ffffff"] tr').each_with_index do |line, index|
      details = line.css('td')
      if index > 0 and details[7].text == gender
        link = details[4].at_css('a')
        parse_result(link[:href]+"&catage=#{cat}") if link
      end
    end


  end

  def parse_result url
    doc = Nokogiri::HTML(open(url))
    doc.css('div.contenu > table[cellpadding="1"] tr').each_with_index do |line, index|
      result = line.css('td')
      if index == 0
        break unless result[8] and result[8].text == 'Cup Points'
      else
        if result[0].text =~ /[0-9]+/
          add_result(url, result)
        end
      end
    end
  end

  def add_result(url, result)
    fis_code = num(result, 2).to_i
    name = result[3].at_css('a')
    @competitors[fis_code] ||= {:fis_code => fis_code, :name => name.text, :href => name[:href],
                                :year => num(result, 4).to_i, :nation => result[5].text,
                                :results => [] }
    @competitors[fis_code][:results] << {:rank => num(result, 0).to_i, :fis_points => num(result, 7).to_f, :cup_points => num(result, 8).to_f, :href => url}
  end

  def num result, index
    result[index].text[/[0-9\.]+/]
  end

  def compare_fis_points x, y
    [x, y].each { |z| return 0 if z[:results].size < 9; z[:results][0, 9].each {|r| return 0 if r[:cup_points] == 0}}
    y[:fis_points] <=> x[:fis_points]
  end

  def standings competitors
    result_comparator = Proc.new {|x, y| x[:cup_points] == y[:cup_points] ? x[:cup_points] == 0 ? x[:rank] <=> y[:rank] : x[:fis_points] <=> y[:fis_points] : y[:cup_points] <=> x[:cup_points]}
    competitor_comparator = Proc.new {|x, y| x[:cup_points] == y[:cup_points] ? compare_fis_points(x, y) : y[:cup_points] <=> x[:cup_points]}
    competitors.each do |c|
      c[:results].sort! &result_comparator
      [:fis_points, :cup_points].each do |attr|
        sum = 0.0
        c[:results].each_with_index {|r, i| sum += r[attr] unless i > 8 or r[:cup_points] == 0}
        c[attr] = sum
      end
      c[:qualified => c[:results].size >= 6]
    end
    competitors.sort! &competitor_comparator
    previous = nil
    competitors.each_with_index do |c, i|
      if previous and competitor_comparator.call(previous, c) == 0
        c[:rank] = previous[:rank]
        previous[:tie]=c[:tie]=true
      else
        c[:rank] = i+1
        c[:tie] = false
      end
      previous = c
    end
  end

  def parse gender, cat
    parse_events gender, cat + 5
    #File.open("log/competitors.yml", "w") {|f| YAML.dump(@competitors, f)}
    #@competitors = YAML.load_file("log/competitors.yml")
    standings(@competitors.values)
  end
end