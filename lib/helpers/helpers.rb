module PathResolver
    PATH_BASE=File.join(Dir.home,'.my_rns')
    PATH_EXPORT_DEFAULT=File.join(Dir.home,'export_default')
end

module Validator
    ERROR_MESSAGE="error los nombres de un cuaderno o una nota no pueden ser vacios o contener los caracteres: / \\  .  <  >  \"  *  ?  : "
    def self.return_book(book)
        if(book.nil? || book =="")
            book="global"
        end 
        return book
    end

    def self.is_valid?(name)
        #esta funcion valida con una ER que el nombre pasado como parametro sea valido para ser un nombre de nota o cuaderno
        (clave=name =~ /[\/|<|>|"|:|.|*|?|\\|\|]+/).nil? && (name != "")
    end

end
