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
          book=Helpers.return_book(book)
          if(not Helpers.are_book_and_title_valid?(book,title)) #me fijo si se ingreso un cuaderno y una nota correcta
            return
          end
          path_cuaderno=File.join(Helpers::PATH_BASE,book)

          if(not Dir.exist?(path_cuaderno))
            puts "el cuaderno ingresado no existe"
            return
          end
          path_nota=File.join(path_cuaderno,title + ".rn")
          if not File.exist?(path_nota)
            File.new(path_nota,'w',0700)
            puts "se creo correctamente la nota: #{title},   en el cuaderno:  #{book}"     
          else
            puts "ya existe una nota con titulo:  #{title},  en el cuaderno:  #{book}"
          end
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
          book=Helpers.return_book(book)
          if(not Helpers.are_book_and_title_valid_and_exist?(book,title))
            return
          end
          path_nota=File.join(Helpers::PATH_BASE,book,title + ".rn")
          File.delete(path_nota)
          puts "se elimino la nota: #{title}, del cuaderno: #{book}"
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
          book=Helpers.return_book(book)
          if(not Helpers.are_book_and_title_valid_and_exist?(book,title)) #me fijo si se ingreso un cuaderno y una nota correcta
            return
          end
          path_note=File.join(Helpers::PATH_BASE,book,title +".rn" )
          puts "seleccione el editor que mas le guste:"
          TTY::Editor.open(path_note)
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
          book=Helpers.return_book(book)
          if(not Helpers.are_book_and_title_valid_and_exist?(book,old_title))
            return
          end
        
          if not Helpers.is_valid?(new_title)
            puts Helpers::ERROR_MESSAGE
            return
          end

          path_book=File.join(Helpers::PATH_BASE,book)
          new_name_path=File.join(path_book,new_title + ".rn")
          old_name_path=File.join(path_book,old_title + ".rn")
          if not File.exist?(new_name_path)
            FileUtils.mv old_name_path,new_name_path
            puts "se cambio el nombre de la nota #{old_title} a #{new_title} en el cuaderno #{book}"     
          else
            puts "ya existe una nota con titulo:  #{new_title},  en el cuaderno:  #{book}"
          end
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
            Dir.each_child(File.join(Helpers::PATH_BASE)){|book1| Helpers.all_notes_of_book(book1) }
            return
          end
          book=Helpers.return_book(book)
          if(not Helpers.is_valid?(book))
            puts Helpers::ERROR_MESSAGE
            return
          end
          if(Dir.exist?(File.join(Helpers::PATH_BASE,book)))
            puts "estas son todas las notas del cuaderno #{book}"
            Helpers.all_notes_of_book(book)
          else
            puts "el cuaderno ingresado no existe"
          end
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
          book=Helpers.return_book(book)
          if(not Helpers.are_book_and_title_valid_and_exist?(book,title)) #me fijo si se ingreso un cuaderno y una nota correcta
            return
          end
          path_note=File.join(Helpers::PATH_BASE,book,title +".rn" )
          puts "contenido de la nota #{title} del cuaderno #{book}:"
          puts File.readlines(path_note)
        end
      end
    end
  end
end
