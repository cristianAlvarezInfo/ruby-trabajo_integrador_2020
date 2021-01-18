require 'fileutils'
module RN
    class Book
        attr_reader :path,:nombre
        
        
        def self.validar_cuaderno_existe(nombre)
            if not Validator.is_valid?(nombre)
                return Validator::ERROR_MESSAGE
            end 
            path=File.join(PathResolver::PATH_BASE,nombre)
            if not Dir.exist?(path)  
                return "El cuaderno #{nombre} no existe"
            end
            return ""
        end
        
        def self.create(nombre)
            book=nil
            error=self.validar_cuaderno_existe(nombre)
            if(error == '')
                book=self.new(nombre)
            end
            return book,error
        end

        def initialize(nombre)
            path=File.join(PathResolver::PATH_BASE,nombre)
            @book=Dir.open(path)
            @path=path
            @nombre=nombre
        end

        def self.crear_cuaderno(nombre)
            if not Validator.is_valid?(nombre)
                return Validator::ERROR_MESSAGE
            end
            path=File.join(PathResolver::PATH_BASE,nombre)
            if not Dir.exist?(path)  
                Dir.mkdir(path,0700) #crea el archivo, File.join concatena la ruta,0700 son los permisos
                return"se creo el cuaderno #{nombre} correctamente"
            else
                return "ya existe un cuaderno con ese nombre"
            end
        end

        
        def eliminar_notas()
            @book.children.each {|file| File.delete(File.join(@path,file))}
        end


        def eliminar_cuaderno()
            self.eliminar_notas()
            Dir.delete(@path)
            @book=nil
            @path=nil
        end

        def self.listar_todos_los_cuadernos()
            return Dir.children(PathResolver::PATH_BASE)
        end

        def renombrar_cuaderno(nuevo_nombre)
            if(@nombre == 'global')
                return "no puede cambiar el nombre al cuaderno global"
            end 
            if not Validator.is_valid?(nuevo_nombre)
                return Validator::ERROR_MESSAGE
            end 
            path=File.join(PathResolver::PATH_BASE,nuevo_nombre)
            if Dir.exist?(path)  
                return "Ya existe un cuaderno con el nombre #{nuevo_nombre}"
            end
            nuevo_path=File.join(PathResolver::PATH_BASE,nuevo_nombre)
            FileUtils.mv @path,nuevo_path
            @path=nuevo_path
            @nombre=nuevo_nombre
            @book=Dir.open(path)
            return ""
           
        end
        def existe_nota(titulo)
            return  File.exist?(File.join(@path,titulo + ".rn"))
        end

        def validar_nota(titulo)
            if(not Validator.is_valid?(titulo))
                return Validator::ERROR_MESSAGE
            end
            if( not self.existe_nota(titulo))
                return "no existe una nota con titulo #{titulo} en el cuaderno #{@nombre} "
            end
            return ""
        end
        def agregar_nota(titulo)
            if(self.existe_nota(titulo))
                return "Ya existe una nota con titulo #{titulo} en el cuaderno #{@nombre}"
            end
            Note.crear_nota(titulo,@path)
            return "se creo la nota #{titulo} en el cuaderno #{@nombre}"
        end

        def eliminar_nota(titulo)
            error=self.validar_nota(titulo)
            if(error != "") then return error end
            Note.eliminar_nota(titulo,@path)
            return "se elimino correctamente la nota #{titulo} del cuaderno #{@nombre}"
        end 

        def obtener_nota(titulo)
            error=self.validar_nota(titulo)
            if(error != "") then return error end
            return Note.new(titulo,self)
        end

        def self.todas_las_notas()
            notas=[]
            Dir.each_child(File.join(PathResolver::PATH_BASE)){|book| notas.concat(Book.new(book).notas) }
            return notas
        end
        
        def notas()
            notas=[]
            @book.each_child{|note| notas.push("cuaderno:#{@nombre},  nota: #{note.delete_suffix(".rn")}")}
            return notas
        end

        def self.exportar_todas_las_notas(path)
            path_exportar_notas=File.join(path,"export_html")
            Dir.each_child(PathResolver::PATH_BASE){|book| Book.new(book).exportar_notas(path)}
        end

        def exportar_notas(path)
            path_notas_exportadas=File.join(path,@nombre)
            if(not Dir.exist?(path_notas_exportadas))#Para mantener la estructura de cuadernos
                Dir.mkdir(path_notas_exportadas,0700)
            end
            @book.each_child{|note| Note.new(note.delete_suffix(".rn"),self).exportar_contenido(path_notas_exportadas)}
        end
    end
end