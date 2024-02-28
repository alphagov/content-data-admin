require "fog-aws"
require "sitemap_generator"

class PartialSitemapGenerator
  def generate_for_organisations(organisations: [])
    raise(StandardError, "No organisations specified") if organisations.empty?

    pages = GdsApi.search.search_enum({
      fields: "link",
      filter_organisations: organisations,
    })

    raise(StandardError, "Sitemap empty") if pages.none?

    SitemapGenerator.verbose = false

    SitemapGenerator::Sitemap.adapter = SitemapGenerator::AwsSdkAdapter.new(ENV["AWS_SITEIMPROVE_SITEMAPS_BUCKET_NAME"])

    SitemapGenerator::Sitemap.default_host = "https://www.gov.uk"
    SitemapGenerator::Sitemap.filename = "sitemap-#{organisations.join('-and-')}"
    SitemapGenerator::Sitemap.public_path = "tmp/"

    # rubocop:disable Rails/SaveBang!
    SitemapGenerator::Sitemap.create do
      pages.each { |page| add page["link"], changefreq: "weekly" }
    end
    # rubocop:enable Rails/SaveBang!

    SitemapGenerator::Sitemap.filename
  end
end
