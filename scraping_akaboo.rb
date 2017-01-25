require "open-uri"
require "nokogiri"

require 'pp'

class Table
  def initialize(table)
    @table = table
  end

  def header?
    @table.attributes.has_key?('bgcolor')
  end

  def data?
    !header?
  end

  def line
    if header?
      @table.search("td").search("b").map{|attr|attr.text}
    else
      @table.search("td").map{|attr|attr.text}
    end
  end
end

class AkabooScraping
  def initialize(url)
    @url = url
  end

  def user_agent
    'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/28.0.1500.63 Safari/537.36'
  end

  def read
    open(@url, "User-Agent"=>user_agent) do |f|
      charset = f.charset
      Nokogiri::HTML.parse(f.read, nil, charset)
    end
  end
end

url = 'http://www.akaboo.jp/event/'
scraping = AkabooScraping.new(url)

lines = []
scraping.read.xpath("//table[5]").search("tr").each do |table|
  table = Table.new(table)
  if table.header?
    lines << [:header, table.line]
  else
    lines << [:body, table.line]
  end
end
pp lines
