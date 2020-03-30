ThinkingSphinx::Index.define :answer, with: :active_record do
  # fields
  indexes body
  indexes author.email, as: :author, sortable: true

  # attrs
  has question_id, user_id, created_at, updated_at
end
