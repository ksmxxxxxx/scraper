require "open-uri"
require "nokogiri"

require 'pp'

url = 'http://www.akaboo.jp/event/'
user_agent = 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/28.0.1500.63 Safari/537.36'
charset = nil
html = open(url, "User-Agent" => user_agent) do |f|
  charset = f.charset
  f.read
end

doc = Nokogiri::HTML.parse(html, nil, charset)

lines = []
doc.xpath("//table[5]").search("tr").each do |table|
  if table.attributes.has_key?('bgcolor')
    lines << [:header, table.search("td").search("b").map{|attr|attr.text}]
  else
    lines << [:body, table.search("td").map{|attr|attr.text}]
  end
end
pp lines
