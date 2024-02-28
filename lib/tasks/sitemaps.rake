desc "Create partial sitemap suitable for Siteimprove ingestion"
task create_partial_sitemap: :environment do |_t, args|
  puts("Created sitemap #{PartialSitemapGenerator.new.generate_for_organisations(organisations: args.extras.to_a)}")
rescue StandardError => e
  puts(e.message)
  abort("Failed to create sitemap")
end
