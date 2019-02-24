class Video < ApplicationRecord
  require 'httparty'
  require 'uri'
  require 'nokogiri'
  has_many :viewings

  def self.scrape(id)
    base_url = "https://www.netflix.com"
    path = "jp/title/#{id.to_s}"
    url = URI.join(base_url, path)
    res = HTTParty.get(url)
    html = Nokogiri::HTML(res.body)
    title = html.css("h1.title-title").text
    # 要素が見つからないときの例外処理を入れること

    runtime = res.body[/"runtime":[0-9]+/]
    runtime = runtime.split(":")[1].to_i
    # 文字列が見つからないときの例外処理を入れること

    [["netflix_id", id], ["title", title], ["runtime", runtime]].to_h
  end
end
