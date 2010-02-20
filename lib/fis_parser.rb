require 'nokogiri'
require 'open-uri'

class FisParser
#require 'rubygems'

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
    #puts name.text
    @competitors[fis_code] ||= {:fis_code => fis_code, :name => name.text, :href => name[:href],
                                :year => num(result, 4).to_i, :nation => result[5].text,
                                :results => [] }
    @competitors[fis_code][:results] << {:rank => num(result, 0).to_i, :fis_points => num(result, 7).to_f, :cup_points => num(result, 8).to_f, :href => url}
  end

  def num result, index
    result[index].text[/[0-9\.]+/]
  end

  def standings competitors
    #puts competitors.inspect
    comparator = Proc.new {|x, y| x[:cup_points] == y[:cup_points] ? x[:fis_points] <=> y[:fis_points] : y[:cup_points] <=> x[:cup_points]}
    competitors.each do |c|
      c[:results].sort! &comparator
      [:fis_points, :cup_points].each do |attr|
        sum = 0
        c[:results].each_with_index {|r, i| sum += r[attr] unless i > 8 or r[:cup_points] == 0}
        c[attr] = sum
      end
      c[:qualified => c[:results].size >= 6]
    end
    competitors.sort! &comparator
    rank = 0
    competitors.each_with_index do |c,i|
      rank = i + 1 unless i > 0 and comparator.call(c, competitors[i-1]) == 0
      c[:rank] = (rank == i+1 ? rank : "")
    end
  end

  def parse gender, cat
    parse_events gender, cat + 5
    standings(@competitors.values)
  end
end