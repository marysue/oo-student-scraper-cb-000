require 'open-uri'
require 'nokogiri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    #returns an array of hashes
    index_url = './fixtures/student-site/index.html'
    studentArr = []
    html = File.read(index_url)
    indexPage = Nokogiri::HTML(html)
    studentCards = indexPage.css(".student-card")
    studentCards.each do |s|
        name = s.css(".student-name").text
        location = s.css(".student-location").text
        url = s.css('a')[0]["href"]
        hash = {
          :name => name,
          :location => location,
          :profile_url => "./fixtures/student-site/#{url}"
         }
         studentArr << hash
    end #for each
    studentArr
  end

  def self.scrape_profile_page(profile_url)
    html = File.read(profile_url)
    page = Nokogiri::HTML(html)
    #<div class="social-icon-container">
   # <a href="http://www.github.com/aenser"><img class="social-icon" src="../assets/img/github-icon.png"/></a>
   # <a href="https://www.linkedin.com/in/aaron-enser-96a756a6"><img class="social-icon" src="../assets/img/linkedin-icon.png"/></a>
   # <a href="https://facebook.com/aaronenser"><img class="social-icon" src="../assets/img/facebook.png"/></a>
   # <a href="https://aaronenser.com"></a>
  #</div>
    container = page.css(".social-icon-container a")

    twitter = ""
    linkedIn = ""
    facebook = ""
    github = ""
    blog = ""
    for i in 0 .. container.size - 1 do
      url = container.css('a')[i]["href"]

      if url.include?("twitter")
        twitter = url
      elsif url.include?("linkedin")
        linkedIn = url
      elsif url.include?("facebook")
        facebook = url
      elsif url.include?("github")
        github = url
      elsif url.include?("blog")
        blog = url
      else
        blog = url #assume this is a blog???
      end
    end 
    profileQuote = ""
    bio = ""

    profileQuote = page.css(".profile-quote").text
    bioSection = page.css(".bio-block")
    bioDiv = bioSection.css("div.description-holder")
    bio = bioDiv.css("p").text
    
    #load up the hash, then remove the empty hashes
    {:twitter => twitter,
      :linkedin => linkedIn,
      :github => github,
      :blog => blog,
      :profile_quote => profileQuote,
      :bio => bio
  }.reject{ |k, v| v == ""}
  end

  def self.printStudents
    studentArr = Scraper::scrape_index_page("")
    studentArr.each do |student|
      puts("====================================\n")
      puts("Name:  #{student[:name]}\n")
      puts("Location: #{student[:location]}\n")
      puts("profile_url: #{student[:profile_url]}\n\n\n")
    end
    nil
  end


end

