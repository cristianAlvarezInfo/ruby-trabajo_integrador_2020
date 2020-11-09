module Helpers
    PATH_BASE=File.join(Dir.home,'.my_rns')
    ERROR_MESSAGE="error los nombres de un cuaderno o una nota no pueden ser vacios o contener los caracteres: / \\  .  <  >  \"  *  ?  : "

    def self.return_book(book)
        if(book.nil? || book =="")
            book="global"
        end 
        return book
    end
    
    def self.delete_notes(path)
        #este metodo elimina las notas del cuaderno que se obtiene a partir del path pasado por parámetro
        cuaderno=Dir.open(path) 
        cuaderno.children.each {|file| File.delete(File.join(cuaderno.path,file))}
        cuaderno.close()
    end

    def self.is_valid?(name)
        #esta funcion valida con una ER que el nombre pasado como parametro sea valido para ser un nombre de nota o cuaderno
        (clave=name =~ /[\/|<|>|"|:|.|*|?|\\|\|]+/).nil? && (name != "")
    end

    def self.are_book_and_title_valid?(book,title)     
        if not (is_valid?(title) && is_valid?(book))
            puts Helpers::ERROR_MESSAGE
            return false
        end
        return true
    end

    def self.are_book_and_title_valid_and_exist?(book,title) 
        if not are_book_and_title_valid?(book,title)
            return false
        end
        path_cuaderno=File.join(Helpers::PATH_BASE,book)
        if(not Dir.exist?(path_cuaderno))
            puts "el cuaderno ingresado no existe"
            return false
        end
        path_nota=File.join(path_cuaderno,title + '.rn')
        if(not File.exist?(path_nota))
            puts "la nota #{title} no existe en el cuaderno #{book}"
            return false
        end
        return true
    end

    def self.all_notes_of_book(book)
        Dir.each_child(File.join(Helpers::PATH_BASE,book)){|note| puts "cuaderno:#{book},  nota: #{note.delete_suffix(".rn")}"}
    end

end
