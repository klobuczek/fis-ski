task :cron => :environment do
   puts "#{Time.now.to_s}: Updating results..."
   puts "done."
end