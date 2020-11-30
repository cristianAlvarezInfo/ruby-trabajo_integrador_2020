require 'fileutils'
require 'tty-editor'
module RN
  module Commands
    module Notes
      class Create < Dry::CLI::Command
        desc 'Create a note'
        argument :title, required: true, desc: 'Title of the note'
        option :book, type: :string, desc: 'Book'

        example [
          'todo                        # Creates a note titled "todo" in the global book',
          '"New note" --book "My book" # Creates a note titled "New note" in the book "My book"',
          'thoughts --book Memoires    # Creates a note titled "thoughts" in the book "Memoires"'
        ]

        def call(title:, **options)
          book = options[:book]
          book=Validator.return_book(book)
          error=Book.validar_cuaderno_existe(book)
          if(error != "") then return puts error end
          cuaderno=Book.new(book)
          puts cuaderno.agregar_nota(title)
        end
    
      end

      class Delete < Dry::CLI::Command
        desc 'Delete a note'

        argument :title, required: true, desc: 'Title of the note'
        option :book, type: :string, desc: 'Book'

        example [
          'todo                        # Deletes a note titled "todo" from the global book',
          '"New note" --book "My book" # Deletes a note titled "New note" from the book "My book"',
          'thoughts --book Memoires    # Deletes a note titled "thoughts" from the book "Memoires"'
        ]

        def call(title:, **options)
          book = options[:book]
          book=Validator.return_book(book)
          error=Book.validar_cuaderno_existe(book)
          if(error != "") then return puts error end
          cuaderno=Book.new(book)
          puts cuaderno.eliminar_nota(title)
        end
      end

      class Edit < Dry::CLI::Command
        desc 'Edit the content a note'

        argument :title, required: true, desc: 'Title of the note'
        option :book, type: :string, desc: 'Book'

        example [
          'todo                        # Edits a note titled "todo" from the global book',
          '"New note" --book "My book" # Edits a note titled "New note" from the book "My book"',
          'thoughts --book Memoires    # Edits a note titled "thoughts" from the book "Memoires"'
        ]

        def call(title:, **options)
          book = options[:book]
          book=Validator.return_book(book)
          error=Book.validar_cuaderno_existe(book)
          if(error != "") then return puts error end
          cuaderno=Book.new(book)
          nota=cuaderno.obtener_nota(title)
          if nota.class == String then return puts nota end
          puts "Seleccione el editor que mas le guste"
          nota.editar()
        end
      end

      class Retitle < Dry::CLI::Command
        desc 'Retitle a note'

        argument :old_title, required: true, desc: 'Current title of the note'
        argument :new_title, required: true, desc: 'New title for the note'
        option :book, type: :string, desc: 'Book'

        example [
          'todo TODO                                 # Changes the title of the note titled "todo" from the global book to "TODO"',
          '"New note" "Just a note" --book "My book" # Changes the title of the note titled "New note" from the book "My book" to "Just a note"',
          'thoughts thinking --book Memoires         # Changes the title of the note titled "thoughts" from the book "Memoires" to "thinking"'
        ]

        def call(old_title:, new_title:, **options)
          book = options[:book]
          book=Validator.return_book(book)
          error=Book.validar_cuaderno_existe(book)
          if(error != "") then return puts error end
          cuaderno=Book.new(book)
          nota=cuaderno.obtener_nota(old_title)
          if nota.class == String then return puts nota end
          puts nota.cambiar_nombre(new_title)
         
        end
      end

      class List < Dry::CLI::Command
        desc 'List notes'

        option :book, type: :string, desc: 'Book'
        option :global, type: :boolean, default: false, desc: 'List only notes from the global book'

        example [
          '                 # Lists notes from all books (including the global book)',
          '--global         # Lists notes from the global book',
          '--book "My book" # Lists notes from the book named "My book"',
          '--book Memoires  # Lists notes from the book named "Memoires"'
        ]

        def call(**options)
          book = options[:book]
          global = options[:global]
          if (book.nil?) && (not global)
            puts "estas son todas las notas de todos los cuadernos: "
            Book.todas_las_notas()
            return
          end
          book=Validator.return_book(book)
          error=Book.validar_cuaderno_existe(book)
          if(error != "") then return puts error end
          cuaderno=Book.new(book)
          cuaderno.notas()
        end
      end

      class Show < Dry::CLI::Command
        desc 'Show a note'

        argument :title, required: true, desc: 'Title of the note'
        option :book, type: :string, desc: 'Book'

        example [
          'todo                        # Shows a note titled "todo" from the global book',
          '"New note" --book "My book" # Shows a note titled "New note" from the book "My book"',
          'thoughts --book Memoires    # Shows a note titled "thoughts" from the book "Memoires"'
        ]

        def call(title:, **options)
          book = options[:book]
          book=Validator.return_book(book)
          error=Book.validar_cuaderno_existe(book)
          if(error != "") then return puts error end
          cuaderno=Book.new(book)
          nota=cuaderno.obtener_nota(title)
          if nota.class == String then return puts nota end
          puts "el contenido de la nota #{title} es:"
          puts nota.contenido()
        end
      end

      class Export < Dry::CLI::Command
        desc 'Export notes'

        option :path, type: :string, desc: 'Path'
        option :note, type: :string, desc: 'Note'
        option :book, type: :string, desc: 'Book'
        option :global, type: :boolean, default: false, desc: 'Export only notes from the global book'

        example [
          'todo                        # Export to HTML a note titled "todo" from the global book',
          '"New note" --book "My book" # Export to HTML  a note titled "New note" from the book "My book"',
          'thoughts --book Memoires    # Export to HTML  a note titled "thoughts" from the book "Memoires"',
          '                 # Export to HTML notes from all books (including the global book)',
          '--global         # Export to HTML notes from the global book',
          '--book "My book" # Export to HTML notes from the book named "My book"',
          '--book Memoires  # Export to HTML notes from the book named "Memoires"',
          '"New note" --book "My book" --path "home/cristian" # Export to HTML and save in "home/cristian" a note titled "New note" from the book "My book"',
          
        ]

        def call(**options)
          note = options[:note]
          book = options[:book]
          global = options[:global]
          path = options[:path]
          puts path
          if(not path.nil?) 
            if(not Dir.exist?(path))
                return puts "La ruta ingresada no existe"
            end
          else
            path=PathResolver::PATH_EXPORT_DEFAULT
          end
          if (note.nil?) && (book.nil?) && (not global)
            puts "Se exportaran a .HTML todas las notas de todos los cuadernos en el destino #{path}: "
            Book.exportar_todas_las_notas(path)
            return
          end
          
          if(global || book.nil?)
            cuaderno=Book.new("global")
          else
            error=Book.validar_cuaderno_existe(book)
            if(error != "") then return puts error end
            cuaderno=Book.new(book)  
          end
          
          if(note.nil?)
            puts "se exportaran a .HTML todas las notas del cuaderno #{cuaderno.nombre} en el destino #{path}"
            cuaderno.exportar_notas(path)
          else
            nota=cuaderno.obtener_nota(note)
            if nota.class == String then return puts nota end
            puts nota.exportar_contenido(path)
          end
        end
      end
    end
  end
end
