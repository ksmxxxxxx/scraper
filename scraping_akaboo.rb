require "open-uri"
require "nokogiri"
require "robotex"
require "sinatra"
require "sinatra/reloader"

get '/view_akaboo' do
  robotex = Robotex.new
  p robotex.allowed?("http://www.akaboo.jp/event/")

  url = 'http://www.akaboo.jp/event/'
  user_agent = 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/28.0.1500.63 Safari/537.36'
  charset = nil
  $html = open(url, "User-Agent" => user_agent) do |f|
    charset = f.charset
    f.read
  end

  $doc = Nokogiri::HTML.parse($html, nil, charset)

  $html = "<h1>イベント一覧</h1>"

  def event_location
    $doc.xpath("//table[5]/tr").each do |tr|
      if !tr.attributes["bgcolor"].nil? && tr.attributes["bgcolor"].value == "#ffc6c6"
        @location = tr.children.search("td").first.children.search("font").children.search("b").text
        return @location
      end
    end
  end
  
  puts event_location

  def regist_space
    $doc.xpath("//table[5]/tr").each do |tr|
      if tr.attributes["height"].value == "40"
        @space_cont = tr.children.search("td[@rowspan]").text
        return @space_cont
      end
    end
  end

  puts regist_space
#  event_location = ""
#  event_url = ""
#  event_title =""
#  deadline_date = ""
#  regist_space = ""
#  entry_fee = ""

#  doc.xpath("//table[5]/tr").each do |tr|
#    if !tr.attributes["bgcolor"].nil? && tr.attributes["bgcolor"].value == "#ffc6c6"
#      event_location = tr.children.search("td").first.children.search("font").children.search("b").text
#      html << "<h2>#{event_location}</h2>"
#      regist_space = tr.next.search("td:nth-last-child(7)").text rescue "(no data)"
#      html << "<p>募集SP：#{regist_space}</p>"
#    else
#      entry_fee = tr.children.search("td:nth-last-child(6)").text rescue "(no data)"
#      deadline_date = tr.children.search("td:nth-last-child(4)").text rescue "(no data)"
#      event_url = tr.children.search("td").first.children.search('a').attr('href').value rescue "(no link)"
#      event_title = tr.children.search('td').first.children.search('b').text rescue "(no title)"
#      html << "<p><a href=#{event_url}>#{event_title}</a><br>参加費: #{entry_fee}&nbsp;最終締切: #{deadline_date}</p>"
#    end
#  end
  return $html
end
