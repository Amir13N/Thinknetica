ThinkingSphinx::Index.define :answer, with: :active_record do
  indexes body

  has question_id
end
