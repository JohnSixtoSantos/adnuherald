require_relative 'twitter_collector'

collector = TwitterCollector.new("University of the Philippines,ateneo,admu,ateneo de manila, up vs admu,uaap,uaap finals, onebigfight, obfight, upfight, battleofkatipunan, uaapseason81")

c = 'x'
running = false

print "Input Command [c - collect, s - stop]:"

while true do
	c = gets.chomp

	if c == 'c' && !running then
		puts "Starting Collection"
		running = true

		Thread.new { 
			collector.startTracking(12)
		}
	else
		collector.stopTracking()

		running = false
		puts "Collection Stopped"

		break
	end
end