require "open-uri"
require "nokogiri"
require "robotex"
require "sinatra"
require "sinatra/reloader"

# 会場
def event_data(doc)
  ret = {}
  title = doc.xpath("//table[5]").search("tr").map{|attr|attr.text}
  ret[:title] = title[3]

  return ret
end

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

  puts event_data(doc)

  return html
end
