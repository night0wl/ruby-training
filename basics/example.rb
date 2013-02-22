class WebPage
  def initialize(dir="/")
    @dir = dir
    @file_system = ArticlesFileSystem.new(dir)
    @articles = load
  end

  def load
    @file_system.load
  end

  def save
    @file_system.save(@articles)
  end

  def new_article(title, body, author=nil)
    article = Article.new(title, body, author)
    @articles << article
  end

  def longest_articles
    @articles.sort_by { |i| -i.body.length }
  end

  def best_articles
    @articles.sort_by { |i| -i.points }
  end

  def worst_articles
    @articles.sort_by { |i| i.points }
  end

  def best_article
    best_articles[0] or raise NoArticlesFound
  end

  def worst_article
    worst_articles[0] or raise NoArticlesFound
  end

  def most_controversial_articles
    @articles.sort_by { |i| -i.votes }
  end

  def votes
    @articles.inject(0) { |sum, article| sum + article.votes }
  end

  def authors
    @articles.uniq { |article| article.author }
  end

  def authors_statistics
    stats = Hash.new(0)
    @articles.each do |article|
      stats[article.author] += 1
    end
    stats
  end

  def best_author
    authors_statistics.sort_by { |key, value| -value }[0][0]
  end


end

class ArticlesFileSystem
  def initialize(dir)
    @dir = dir
  end

  def file_name(article)
    File.join(
      @dir, article.title.downcase.gsub(" ", "_") + ".article"
      )
  end

  def file_content(attrs)
      attrs.join("||")
  end

  def save(articles)
    articles.each do |article|
      attrs = [article.author, article.likes, article.dislikes, article.body]

      File.open(file_name(article), 'w') do |f|
        f.write(file_content(attrs))
      end
    end
  end

  def load
    array = Dir.entries(@dir)
    array = array.reject{ |i| !i.match(/\.article$/) }
    array.map{ |i|
      author, likes, dislikes, body = File.read(File.join(@dir, i)).split('||')
      i.slice! ".article"
      article = Article.new(i.tr("_"," ").capitalize, body, author)
      article.likes = likes.to_i
      article.dislikes = dislikes.to_i
      article
    }
  end
end

class Article
  attr_reader :title, :body, :author, :created_at
  attr_accessor :likes, :dislikes

  def initialize(title, body, author=nil)
    @title, @body, @author = title, body, author
    @created_at = Time.now
    @likes = @dislikes = 0
  end

  def like!
    @likes += 1
  end

  def dislike!
    @dislikes += 1
  end

  def points
    @likes - @dislikes
  end

  def votes
    @likes + @dislikes
  end

  def long_lines
    (0..(@body.length-1)/80).map{|i|@body[i*80,80]}
  end

  def length
    @body.length
  end

  def truncate(limit)
    if @body.length > limit
      trunc = @body[0...limit-3]
      trunc += "..."
      trunc
    else
      @body
    end
  end

  def contain?(regexp)
    !!@body.match(regexp)
  end
end
