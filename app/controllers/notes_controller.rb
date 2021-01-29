class NotesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_book ,except: [:export]
  before_action :set_note, only: [:show, :edit, :update, :destroy,:export]


  # GET /notes
  # GET /notes.json
  def index
    @notes = @book.notes
  end

  # GET /notes/1
  # GET /notes/1.json
  def show
  end

  # GET /notes/new
  def new
    @note = @book.notes.new
  end

  # GET /notes/1/edit
  def edit
  end

  def export
  end
  # POST /notes
  # POST /notes.json
  def create
    @note = Note.new(note_params)
    @note.book= @book
    respond_to do |format|
      if @note.save
        format.html { redirect_to book_notes_path, notice: 'Note was successfully created.' }
        format.json { render :show, status: :created, location: @note }
      else
        format.html { render :new }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /notes/1
  # PATCH/PUT /notes/1.json
  def update
    respond_to do |format|
      if @note.update(note_params)
        format.html { redirect_to book_notes_path, notice: 'Note was successfully updated.' }
        format.json { render :show, status: :ok, location: @note }
      else
        format.html { render :edit }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /notes/1
  # DELETE /notes/1.json
  def destroy
    @note.destroy
    respond_to do |format|
      format.html { redirect_to book_notes_path, notice: 'Note was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_book
      @book=ApplicationHelper::return_book(current_user,params[:book_id])
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_note
      begin
        @note = Note.find(params[:id])
        if @note.book.user_id != current_user.id then raise  end

      rescue
        raise ActionController::RoutingError.new('Not Found')
      end
    end

    # Only allow a list of trusted parameters through.
    def note_params
      params.require(:note).permit(:title, :content, :book_id)
    end

  
end
