ThinkingSphinx::Index.define :user, with: :active_record do
  # fields
  indexes email

  # attrs
  has created_at, updated_at
end
