task :cron => 'load:season'

namespace :load do
  task :all => :environment do
    timer do
      FisParser.load_seasons(Season.earliest..Season.current.to_i)
    end
  end

  task :season => :environment do
    timer do
      ActiveRecord::Base.transaction { FisParser.load_season((ENV['season'] || Season.current).to_i) }
    end
  end
end

task :fix => :environment do
  ActiveRecord::Base.transaction do
    Race.all(:include => {:results => :competitor}).each { |race| race.update_age_class_ranks }
  end
end

task :rebuild => ['db:migrate', 'load:all']

task :double => :environment do
  ActiveRecord::Base.connection.execute "update races set factor=2 where codex in (#{ENV['codex']}) and season = #{Season.current.to_i}"
end

def timer
  puts "Updating results..."
  start = Time.new
  yield
  puts "Results updated in #{Time.now - start}"
end