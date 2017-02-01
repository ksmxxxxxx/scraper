require "open-uri"
require "nokogiri"

class AkabooScraping
  def url
    'http://www.akaboo.jp/event/'
  end

  def user_agent
    'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/28.0.1500.63 Safari/537.36'
  end

  def read
    open(url, "User-Agent"=>user_agent) do |f|
      charset = f.charset
      Nokogiri::HTML.parse(f.read, nil, charset)
    end
  end

  def tables
    all_tables = []
    tables = {}
    rowspan = nil
    date = nil
    local = nil
    uri = nil
    header = [:date, :location, :uri, :title, :regist_cout, :fee, :last_limit_date, :nomal_admittance, :cut_type, :etc_info]

    read.xpath("//table[5]").search("tr").each do |t|
      table = Table.new(t)
      if table.header?
        all_tables << tables if tables.size.nonzero?
        tables = []
        rowspan = nil
        date = table.line[0].split(/\s/)[0]
        local = table.line[0].split(/\s/)[1]
        next
      end

      if table.data?
        line = table.line
        if line.size == 8
          rowspan = line[1]
        else
          line = [line[0], rowspan] + line[1..-1]
        end
        line = [[date, local] + line].flatten

        tables << Hash[*(header.zip(line).flatten)]
      end
    end

    return all_tables
  end

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
      row = TableRow.new(@table)
      link = row.link
      if link.nil?
        row.texts
      else
        [link] + row.texts[0..1]
      end
    end
  end

  class TableRow
    def initialize(line)
      @line = line
    end

    def fields
      @line.search("td").to_a
    end

    def texts
      fields.map{|attr|attr.text}
    end

    def link
      return @line.search("a").attribute("href").value
    rescue
      return nil
    end
  end
end

scraping = AkabooScraping.new
scraping.tables.each do |table|
  table.each do |line|
    p line
  end
  puts ''
end
