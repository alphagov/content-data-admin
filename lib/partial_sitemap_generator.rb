require "sitemap_generator"

class PartialSitemapGenerator
  def generate_for_organisations(organisations: [])
    raise(StandardError, "No organisations specified") if organisations.empty?

    pages = GdsApi.search.search_enum({
      fields: "link",
      filter_organisations: organisations,
    })

    raise(StandardError, "Sitemap empty (are the organisation slugs correct?)") if pages.none?

    SitemapGenerator.verbose = false

    SitemapGenerator::Sitemap.adapter = SitemapGenerator::AwsSdkAdapter.new(ENV["AWS_SITEIMPROVE_SITEMAPS_BUCKET_NAME"])

    SitemapGenerator::Sitemap.default_host = "https://www.gov.uk"
    SitemapGenerator::Sitemap.filename = "sitemap-#{organisations.join('-and-')}"
    SitemapGenerator::Sitemap.public_path = ENV.fetch("TMPDIR", "/tmp")

    # rubocop:disable Rails/SaveBang!
    SitemapGenerator::Sitemap.create do
      pages.each { |page| add page["link"], changefreq: "weekly" }
    end
    # rubocop:enable Rails/SaveBang!

    "https://#{ENV['AWS_SITEIMPROVE_SITEMAPS_BUCKET_NAME']}.s3.amazonaws.com/#{SitemapGenerator::Sitemap.filename}.xml.gz"
  end
end
