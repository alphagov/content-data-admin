desc "Run govuk-lint on all files"
task "lint" do
  sh "govuk-lint-ruby app config lib spec --format clang --rails"
  sh "govuk-lint-sass app/assets/stylesheets"
end
