class AccessibilityIssuesPresenter
  attr_reader :issue_list

  def initialize(issue_list)
    @issue_list = issue_list
  end
end
