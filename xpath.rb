require 'rubygems' # not required for ruby 1.9 or if you installed without gem
require 'selenium-webdriver'
require "nokogiri"
require "open-uri"

driver = Selenium::WebDriver.for :chrome
driver.get "http://www.akaboo.jp/event/"

