class LinkTitleResolver
  def initialize(base_path)
    @base_path = base_path
  end

  def title_for_link(link)
    elements = content_body.search("a[href=\"#{link}\"]")
    return "(Unable to find link text)" unless elements.any?

    elements.first.text
  end

private

  def content_body
    @content_body ||= Nokogiri::HTML(extract_content_body_from_item)
  end

  def extract_content_body_from_item
    content_item = GdsApi.content_store.content_item(@base_path)
    details = content_item.to_hash["details"]
    return details["body"] if details.key?("body")
    return details["parts"].map { |p| p["body"] }.join(" - ") if details.key?("parts")

    nil
  end
end
