class QualityAssuranceIssuesPresenter
  attr_reader :summary_info

  def initialize(quality_assurance_issues, summary_info)
    @quality_assurance_issues = quality_assurance_issues
    @summary_info = summary_info
  end

  def issue_list
    {
      misspellings: misspellings,
    }
  end

  def link
    summary_info._siteimprove.quality_assurance.page_report.href
  end

  def misspellings
    @quality_assurance_issues[:misspellings].map do |spelling|
      {
        word: spelling.word,
        suggestions: spelling.suggestions&.join(', '),
        quality_assurance_direct_link: quality_assurance_misspelling_direct_link(spelling.id),
      }
    end
  end

  def quality_assurance_misspelling_direct_link(spelling_id)
    "#{link.gsub(/QualityAssurance\/(\d*)/,"Inspector/\\1/QualityAssurance")}#issue/misspellings/#{spelling_id}"
  end
end
