# author mastermaiknemo github
require 'sinatra'
require 'sinatra/reloader'
require 'haml'
require 'json'
require 'mechanize'

get '/' do 
	$counter = 1
	haml :layout
end

get '/pagein' do 
	$title = params['val']
	a = Mechanize.new
	req1 = a.get "https://en.wikipedia.org/wiki/#{$title}"
	puts $title
	$nodes1 = req1.parser.xpath "/html/body/div[3]/div[3]/div[5]/div/p[count(preceding::p) < 3]"
	links = []
	$nodes1.xpath("a/@href").each do |l|
		links.push l.to_s.gsub(/^\/wiki\//, '')
	end
	$backlinks = links
	content_type :json
	{:backlinks => $backlinks}.to_json
end

get '/getnodes' do
	nodes = []
	nodes.push ({:id => $counter.to_s, :label => $title})
	$backlinks.each do |b|
		$counter += 1
		nodes.push ({:id => $counter.to_s, :label => b})
	end
	$counter += 1
	nodes.to_json
end
