require 'nokogiri'
require 'rest-client'

page = Nokogiri::HTML(
  RestClient.get("https://github.com/tenderlove?tab=repositories"))

link_tags = page.css("ul.repolist > li.source > h3 > a")

link_tags.each do |link|
  repo_name = link.text
  repo_href = link.attr('href')
  puts "#{repo_name}: #{repo_href}"
end
