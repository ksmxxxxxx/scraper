require "open-uri"
require "nokogiri"
require "robotex"
require "sqlite3"

robotex = Robotex.new
p robotex.allowed?("http://www.youyou.co.jp/sche.php")

db =SQLite3::Database.new("event_list.db")
db.execute("CREATE TABLE IF NOT EXISTS event (title varchar(100), place varchar(50));")

url ="http://www.youyou.co.jp/sche.php"
user_agent = "Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/28.0.1500.63 Safari/537.36"

html = open(url, "User-Agent" => user_agent) do |f|
  f.read
end

doc = Nokogiri::HTML.parse(html, nil, "utf-8")

event_location = ""
event_title =""

doc.xpath("//*[@id=\"left\"]").each do |eventlist|
  event_location =  eventlist.xpath("//td[@class=\"place\"]").text
  event_title = eventlist.xpath("//td[@class=\"title\"]").text
  db.execute "INSERT INTO event values ( ?, ? );", ["#{event_location}", "#{event_title}"]
end
