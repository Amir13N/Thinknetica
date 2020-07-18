# frozen_string_literal: true

module ApplicationHelper
  def gist(link)
    Octokit.gist(link.url.split('/').last)
  end
end
