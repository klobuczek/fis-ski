task :cron => :environment do
  start = Time.new
  puts "#{Time.now.to_s}: Updating results..."
  FisParser.parse_events
  puts "All results fetched in #{Time.now - start}"
end