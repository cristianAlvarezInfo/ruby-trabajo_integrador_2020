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
          puts Book.crear_cuaderno(name)
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
          if(global || name == "global")
            cuaderno=Book.new("global")
            cuaderno.eliminar_notas()
            puts "se borraron todas las notas del cuaderno global"
          else
            error=Book.validar_cuaderno_existe(name)
            if(error != "")
                return puts error
            end
            cuaderno=Book.new(name)
            cuaderno.eliminar_cuaderno()
            puts "se elimino el cuaderno #{name} junto con todas sus notas"
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
          Book.listar_todos_los_cuadernos().each{|book| puts book}
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
          error=Book.validar_cuaderno_existe(old_name)
          if(error != "")
              return puts error
          end
          cuaderno=Book.new(old_name)
          error= cuaderno.renombrar_cuaderno(new_name)
          if error != ""
            puts error
            return
          end
          puts "se renombro el cuaderno #{old_name} a  #{new_name}"
        end
      end
    end
  end
end
