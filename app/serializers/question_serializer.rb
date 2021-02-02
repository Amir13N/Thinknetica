# frozen_string_literal: true

class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :created_at, :updated_at, :short_title, :file_urls

  has_many :answers
  has_many :comments
  has_many :files
  has_many :links

  belongs_to :user

  def short_title
    object.title.truncate(7)
  end

  def file_urls
    object.files.map(&:service_url)
  end
end
