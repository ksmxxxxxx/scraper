require 'open-uri'
require 'nokogiri'
require 'robotex'
require 'sinatra'

get '/view_eventlist' do
  robotex = Robotex.new
  p robotex.allowed?("http://www.akaboo.jp/event/")

  url = 'http://www.akaboo.jp/event/'
  user_agent = 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/28.0.1500.63 Safari/537.36'
  charset = nil
  html = open(url, "User-Agent" => user_agent) do |f|
    charset = f.charset
    f.read
  end

  doc = Nokogiri::HTML.parse(html, nil, charset)

  html = "<h1>イベント一覧</h1>"


#  date = ""
#  x.xpath("//table[5]/tr").each do |tr|
#    if !tr.attributes["bgcolor"].nil? && tr.attributes["bgcolor"].value == "#ffc6c6"
#      date_text = tr.children.search('td').first.children.children.text
#      puts date_text
#    else
#      url = tr.children.search('td').first.children.search('a').attr('href').value rescue "(no link)"
#      title = tr.children.search('td').first.children.search('b').text rescue "(no title)"
#      puts "　#{title} -> #{url}"
#    end
#  end

  event_location = ""
  event_url = ""
  event_title =""

  doc.xpath("//table[5]/tr").each do |tr|
    if !tr.attributes["bgcolor"].nil? && tr.attributes["bgcolor"].value == "#ffc6c6"
      event_location = tr.children.search("td").first.children.search("font").children.search("b").text
      html << "<h2>#{event_location}</h2>"
#     else
#       event_url = tr.children.search('td').first.children.('a').attr('href').value rescue "(no link)"
#       event_title = tr.children.search('td').first.children.search('b').text rescue "(no title)"
#       html << "<p><a href=#{event_url}>#{event_title}</a></p>"
    end
  end
  return html
end
