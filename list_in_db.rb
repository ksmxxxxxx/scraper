require "open-uri"
require "nokogiri"
require "robotex"
require "splite3"

robotex = Robotex.new
p robotex.allowed?("http://www.youyou.co.jp/sche.php")

bd =SQLite3::Database.new("event_list.db")
db.execute("CREATE TABLE IF NOT EXISTS event (title varchar(100), place varchar(50));")

url ="http://www.youyou.co.jp/sche.php"
user_agent = "Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/28.0.1500.63 Safari/537.36"

charset = nil
html = open(url, "User-Agent" => user_agent) do |f|
  charset = f.charset
  f.read

end

doc = Nokogiri::HTML.parse(html, nil, charset)

event_location = ""
event_title =""

doc.xpath("//*[@id=\"left\"]").each do |eventlist|
  puts eventlist.xpath("//td[@class=\"place\"]").text
  puts eventlist.xpath("//td[@class=\"title\"]").text
  db.execute "INSERT INTO event values ( ?, ? );", ["#{eventlist.xpath("//td[@class=\"place\"]").text}", "#{title.xpath("//td=[@class=\"title\"]")}"]
end
