
require 'fileutils'
module RN
  module Commands
    module Books
      class Create < Dry::CLI::Command
        desc 'Create a book'

        argument :name, required: true, desc: 'Name of the book'

        example [
          '"My book" # Creates a new book named "My book"',
          'Memoires  # Creates a new book named "Memoires"'
        ]

        def call(name:, **)
          if not Helpers.is_valid?(name)
            puts Helpers::ERROR_MESSAGE
            return
          end
          path=File.join(Helpers::PATH_BASE,name)
          if not Dir.exist?(path)  
            Dir.mkdir(path,0700) #crea el archivo, File.join concatena la ruta,0700 son los permisos
            puts "se creó el cuaderno #{name} correctamente"
          else
            puts "ya existe un cuaderno con ese nombre"
          end
        end
      end

      class Delete < Dry::CLI::Command
        desc 'Delete a book'
        argument :name, required: false, desc: 'Name of the book'
        option :global, type: :boolean, default: false, desc: 'Operate on the global book'

        example [
          '--global  # Deletes all notes from the global book',
          '"My book" # Deletes a book named "My book" and all of its notes',
          'Memoires  # Deletes a book named "Memoires" and all of its notes'
        ]

        def call(name: nil, **options)
          global = options[:global]
          if (not name.nil?)&& (not Helpers.is_valid?(name))
            puts Helpers::ERROR_MESSAGE
            return
          end
          if(global || name == "global")  #se fija si se selecciono la opcion global, si es así se eliminan todos los archivos de la carpeta global
            Helpers.delete_notes(File.join(Helpers::PATH_BASE,'global'))
            puts "se eliminaron todas las notas del cuaderno global"
          elsif not name.nil?
            path=File.join(Helpers::PATH_BASE,name)
            if Dir.exist?(path) #verificar si el nombre ingresado es correcto
              Helpers.delete_notes(path)
              Dir.delete(path)
              puts "se elimino correctamente el cuaderno #{name}"
            else
              puts "no existe el cuaderno #{name}"
            end

          end
        end
      end

      class List < Dry::CLI::Command
        desc 'List books'

        example [
          '          # Lists every available book'
        ]

        def call(*)
          puts "Todos los cuadernos que tienes creados son:"
          Dir.each_child(Helpers::PATH_BASE){|book| puts book}
        end
      end

      class Rename < Dry::CLI::Command
        desc 'Rename a book'

        argument :old_name, required: true, desc: 'Current name of the book'
        argument :new_name, required: true, desc: 'New name of the book'

        example [
          '"My book" "Our book"         # Renames the book "My book" to "Our book"',
          'Memoires Memories            # Renames the book "Memoires" to "Memories"',
          '"TODO - Name this book" Wiki # Renames the book "TODO - Name this book" to "Wiki"'
        ]

        def call(old_name:, new_name:, **)
          if (not Helpers.is_valid?(old_name)) || (not Helpers.is_valid?(new_name))
            puts Helpers::ERROR_MESSAGE
            return
          end
          if(old_name == "global")  #se fija si se selecciono la opcion global, si es así se eliminan todos los archivos de la carpeta global
            puts "no se puede cambiar el nombre del cuaderno global"
            return
          end
          old_name_path=File.join(Helpers::PATH_BASE,old_name)
          new_name_path=File.join(Helpers::PATH_BASE,new_name) 
          if not Dir.exist?(old_name_path) #verificar si el nombre ingresado es correcto
            puts "no existe el cuaderno #{old_name}"
            return
          end
          if Dir.exist?(new_name_path)  #verificamos que el nuevo nombre no exista en el cuaderno 
            puts "ya existe un cuaderno con nombre #{new_name}"
            return
          end
          FileUtils.mv old_name_path,new_name_path
          puts "se renombro el cuaderno #{old_name} a  #{new_name}"
        end
      end
    end
  end
end
