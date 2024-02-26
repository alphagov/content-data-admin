class LinkTitleResolver
  def initialize(base_path)
    @base_path = base_path
  end

  def title_for_link(link)
    regexp = Regexp.new("<a.*href=\"#{link}\"[^>]*>([^<]*)<\/a>")
    matches = regexp.match(content_body)
    return "(Unable to find link text)" unless matches.captures.any?

    matches.captures[0]
  end

  def content_body
    @content_body ||= extract_content_body_from_item
  end

  def extract_content_body_from_item
    content_item = GdsApi.content_store.content_item(@base_path)
    details = content_item.to_hash["details"]
    return details["body"] if details.key?("body")
    return details["parts"].map { |p| p["body"] }.join(" - ") if details.key?("parts")

    ""
  end
end
