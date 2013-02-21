class Article
    attr_reader :title, :body, :author, :created_at
    attr_accessor :likes, :dislikes

    def initialize(title, body, author)
        @title = title
        @body = body
        @author = author
        @created_at = Time.now
    end
end
