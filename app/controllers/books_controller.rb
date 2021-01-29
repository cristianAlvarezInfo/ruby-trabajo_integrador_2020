class BooksController < ApplicationController
  before_action :set_user
  before_action :authenticate_user!
  before_action :set_book , only: [:show, :edit, :update, :destroy, :export_notes]
 
  # GET /books
  # GET /books.json
  def index
    @books = @user.books
  end

  # GET /books/1
  # GET /books/1.json
  def show
  end

  # GET /books/new
  def new
    @book = @user.books.new
  end

  # GET /books/1/edit
  def edit
  end

  def export_notes
  end

  def export_all_notes_of_current_user
  end

  # POST /books
  # POST /books.json
  def create
    @book = @user.books.new(book_params)

    respond_to do |format|
      if @book.save
        format.html { redirect_to @book, notice: 'Book was successfully created.' }
        format.json { render :show, status: :created, location: @book }
      else
        format.html { render :new }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /books/1
  # PATCH/PUT /books/1.json
  def update
    respond_to do |format|
      if @book.title== 'global'
        format.html { redirect_to books_url, notice: 'the global book can´t be changed.' }
        format.json { head :no_content }
      elsif @book.update(book_params)
        format.html { redirect_to @book, notice: 'Book was successfully updated.' }
        format.json { render :show, status: :ok, location: @book }
      else
        format.html { render :edit }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /books/1
  # DELETE /books/1.json
  def destroy
    respond_to do |format|
      if @book.title== 'global'
          format.html { redirect_to books_url, notice: 'the global book can´t be destroyed.' }
          format.json { head :no_content }
      else
        @book.destroy
          format.html { redirect_to books_url, notice: 'Book was successfully destroyed.' }
          format.json { head :no_content }
      end
    end
  end

  private
    def set_user
      @user = current_user
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_book
      @book=ApplicationHelper::return_book(current_user,params[:id])
    end

    # Only allow a list of trusted parameters through.
    def book_params
      params.require(:book).permit(:title, :user_id)
    end
end

