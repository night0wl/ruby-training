class Article
    attr_reader :title, :body, :author, :created_at
    attr_accessor :likes, :dislikes

    def initialize(title, body, author)
        @title = title
        @body = body
        @author = author
        @created_at = Time.now
        @likes = 0
        @dislikes = 0
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
