class ArticlesFileSystem
    def initialize(dir)
        if dir[-1] == "/"
            @dir = dir
        else
            @dir = dir + "/"
        end
    end

    def save(articles)
        articles.each do |article|
            f_name = @dir + article.title.downcase.gsub(" ", "_") + ".article"
            attrs = [
                article.author,
                article.likes,
                article.dislikes,
                article.body
                ]
            File.open(f_name, 'w') do |f|
                f.write(attrs.join("||"))
            end
        end
    end

    def load
        array = Dir.entries(@dir)
        array = array.reject{ |i| !i.match(/\.article$/) }
        array.map{ |i|
            author, likes, dislikes, body = File.read(@dir+i).split('||')
            article = Article.new(
                i.tr("_"," ").capitalize,
                body,
                author
            )
            article.likes = likes.to_i
            article.dislikes = dislikes.to_i
            article
        }
        array
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
