# name: discourse-github-linkback
# about: Links Github content back to a Discourse discussion
# version: 0.1
# authors: Robin Ward
# url: https://github.com/discourse/discourse-github-linkback

enabled_site_setting :github_linkback_enabled

after_initialize do
  AdminDashboardData.add_problem_check do
    I18n.t("github_linkback.not_supported")
  end

  require_dependency File.expand_path('../app/lib/github_linkback.rb', __FILE__)
  require_dependency File.expand_path('../app/jobs/regular/create_github_linkback.rb', __FILE__)

  DiscourseEvent.on(:post_created) do |post|
    GithubLinkback.new(post).enqueue
  end

  DiscourseEvent.on(:post_edited) do |post|
    GithubLinkback.new(post).enqueue
  end
end
