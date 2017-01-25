require "open-uri"
require "nokogiri"

url = 'http://www.akaboo.jp/event/'
user_agent = 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/28.0.1500.63 Safari/537.36'
charset = nil
html = open(url, "User-Agent" => user_agent) do |f|
  charset = f.charset
  f.read
end

doc = Nokogiri::HTML.parse(html, nil, charset)

# 会場
def event_data(doc)

  data = doc.xpath("//table[5]/tr/td").map{|attr|attr.text}
  p data[2]
end

  puts event_data(doc)

