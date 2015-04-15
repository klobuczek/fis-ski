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

namespace :reload do
  task season: ['delete:season', 'load:season']
end

namespace :delete do
  task season: :environment do
    Race.where(season: (ENV['season'] || Season.current).to_i).destroy_all
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