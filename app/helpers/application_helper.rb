module ApplicationHelper
    def self.return_book(user,book_id)
        begin
            book= user.books.find(book_id)
            return book
        rescue
            raise ActionController::RoutingError.new('Not Found')
          end
          
    end
end
