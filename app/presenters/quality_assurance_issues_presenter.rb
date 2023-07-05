class QualityAssuranceIssuesPresenter
  attr_reader :summary_info

  def initialize(quality_assurance_issues, summary_info)
    @quality_assurance_issues = quality_assurance_issues
    @summary_info = summary_info
  end

  def issue_list
    {
      misspellings:,
      broken_links:,
    }
  end

  def link
    summary_info._siteimprove.quality_assurance.page_report.href
  end

  def misspellings
    @quality_assurance_issues[:misspellings].map do |spelling|
      {
        word: spelling.word,
        suggestions: spelling.suggestions&.join(", "),
        quality_assurance_direct_link: quality_assurance_misspelling_direct_link(spelling.id),
      }
    end
  end

  def broken_links
    @quality_assurance_issues[:broken_links].map do |link|
      {
        url: link.url,
        message: link.message,
        quality_assurance_direct_link: quality_assurance_broken_links_direct_link(link.id),
      }
    end
  end

  def quality_assurance_misspelling_direct_link(spelling_id)
    "#{quality_assurance_direct_link}/Misspellings/#{spelling_id}"
  end

  def quality_assurance_broken_links_direct_link(link_id)
    "#{quality_assurance_direct_link}/BrokenLinks/#{link_id}"
  end

  def quality_assurance_direct_link
    qa_link = link.gsub(/QualityAssurance\/(\d*)/, "Inspector/\\1/QualityAssurance")
    formatted_link = qa_link.gsub(/PageDetails\/Report/, "Page")
    "#{formatted_link}#/Issue"
  end
end
