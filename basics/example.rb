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
        return @likes - @dislikes
    end

    def votes
        return @likes + @dislikes
    end
end
