ThinkingSphinx::Index.define :comment, with: :active_record do
  indexes body

  has commentable_id
  has commentable_type
end
