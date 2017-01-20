require "open-uri"
require "nokogiri"
require "robotex"
require "sinatra"
require "sinatra/reloader"

get '/view_akaboo' do
  robotex = Robotex.new
  robotex.allowed?("http://www.akaboo.jp/event/")

  url = 'http://www.akaboo.jp/event/'
  user_agent = 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/28.0.1500.63 Safari/537.36'
  charset = nil
  html = open(url, "User-Agent" => user_agent) do |f|
    charset = f.charset
    f.read
  end

  doc = Nokogiri::HTML.parse(html, nil, charset)

  html = "<h1>イベント一覧</h1>"

  def event_location(doc)
    doc.xpath("//table[5]/tr").each do |tr|
      if !tr.attributes["bgcolor"].nil? && tr.attributes["bgcolor"].value == "#ffc6c6"
        location = tr.children.search("td").first.children.search("font").children.search("b").text
        return location
      end
    end
  end
  
  puts event_location

  def regist_space(doc)
    doc.xpath("//table[5]/tr").each do |tr|
      if tr.attributes["height"].value == "40"
        space_cont = tr.children.search("td[@rowspan]").text
        return space_cont
      end
    end
  end

  puts regist_space
  return html
end
