def load_season season
  ActiveRecord::Base.transaction do
    FisParser.update_events season
    Race.find(:all, :conditions => ["season = ? and href is not null and (comments is null or comments != 'Cancelled') and (status is null or status != 'loaded') and date < ?", season, Time.now + 1.week]).each do |race|
      ActiveRecord::Base.transaction do
        if FisParser.parse_results(race) > 0
          race.update_attribute(:status, 'loaded')
          race.update_category_ranks
        end
      end
    end
  end
end

task :cron => :environment do
  start = Time.new
  puts "Updating results..."
  load_season Season.current
  puts "Results updated in #{Time.now - start}"
end

namespace :load do
  task :all => :environment do
    start = Time.new
    puts "Updating results..."
    (Season.earliest..Season.current).each {|s| load_season s}
    puts "Results updated in #{Time.now - start}"
  end
end

task :fix => :environment do
  ActiveRecord::Base.transaction do
    Race.all(:include => {:results => :competitor}).each {|race| race.update_category_ranks }
  end
end

task :rebuild => ['db:migrate', 'load:all']

task :double => :environment do
  ActiveRecord::Base.connection.execute "update races set factor=2 where codex in (#{ENV['codex']})"  
end