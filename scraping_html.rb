# URLにアクセスするためのライブラリの読み込み
require 'open-uri'

# スクライピング先URL
url = 'http://www.akaboo.jp/event/'
# UAの偽装

user_agent = 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/28.0.1500.63 Safari/537.36'
charset = nil
html = open(url, "User-Agent" => user_agent) do |f|
  charset = f.charset # 文字種別を取得
  f.read
end

# htmlに出力
puts html
