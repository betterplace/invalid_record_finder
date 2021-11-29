ActiveRecord::Schema.define(version: 20321110173325) do
  create_table 'users', force: :cascade do |t|
    t.string 'first_name'
  end

  create_table 'blogs', force: :cascade do |t|
    t.string 'title'
  end
end
