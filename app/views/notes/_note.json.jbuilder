json.extract! note, :id, :title, :content, :book_id, :created_at, :updated_at
json.url note_url(note, format: :json)
