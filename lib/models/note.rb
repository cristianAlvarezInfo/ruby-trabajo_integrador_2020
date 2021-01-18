require 'redcarpet'
require 'redcarpet/compat'
module RN
    class Note
        attr_reader :titulo
        def initialize(titulo,book)
            @book=book
            nota=File.join(@book.path,titulo + ".rn")
            @path=nota
            @titulo=titulo
        end

        def self.crear_nota(titulo,path_book)  #preguntar si va en el cuaderno
            path_nota=File.join(path_book,titulo + ".rn")
            File.new(path_nota,'w',0700)
        end
        
        def self.eliminar_nota(titulo,path_book)
            path_nota=File.join(path_book,titulo + ".rn")
            File.delete(path_nota)
        end

        def editar()
            TTY::Editor.open(@path)
        end

        def cambiar_nombre(nuevo_titulo)
            if(@book.existe_nota(nuevo_titulo))
                return "ya existe una nota con titulo #{nuevo_titulo} en el cuaderno #{@book.nombre} "
            end
            nuevo_path=File.join(@book.path,nuevo_titulo + ".rn")
            FileUtils.mv @path,nuevo_path
            titulo_viejo=@titulo
            @path=nuevo_path
            @titulo=nuevo_titulo
            return "se cambio el titulo de la nota #{titulo_viejo} a #{nuevo_titulo} en el cuaderno #{@book.nombre}"
        end

        def contenido()
            contenido = ''
            nota_contenido = File.open(@path, "r") 
            nota_contenido.each_line do |line|
              contenido += line
            end
            return contenido
           
        end

        def exportar_contenido(path)
            path_nota=File.join(path,@titulo + ".HTML")
            if(File.exist?(path_nota))
                File.delete(path_nota)#en caso de que ya exista una nota con el mismo nombre dentro del directorio la elimino
            end
            contenido_texto_rico= Markdown.new(self.contenido()).to_html
            File.new(path_nota,'w',0700)
            File.write(path_nota,contenido_texto_rico)
            return "se exporto a HTML la nota #{@titulo} del cuaderno #{@book.nombre} en el destino #{path}"
        end
    end

end