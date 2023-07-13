SI_BASE_URI = "https://api.eu.siteimprove.com/v2".freeze

def siteimprove_has_matching_pages
  headers = { "content-type" => "application/json" }
  body = {
    "items" => [
      {
        "id" => 2,
        "title" => "Matched Page",
        "url" => "https://www.gov.uk/base/path",
        "_links" => {
          "details" => {
            "href" => "https://www.gov.uk/base/path",
          },
        },
      },
      {
        "id" => 3,
        "title" => "Close Match Page",
        "url" => "https://www.gov.uk/base/path/subpage",
        "_links" => {
          "details" => {
            "href" => "https://www.gov.uk/base/path/subpage",
          },
        },
      },
    ],
    "total_items" => 2,
    "total_pages" => 1,
    "links" => {
      "next" => {
        "href" => "string",
      },
      "prev" => {
        "href" => "string",
      },
      "self" => {
        "href" => "string",
      },
    },
  }.to_json
  stub_request(:get, "#{SI_BASE_URI}/sites/1/content/pages?url=https://www.gov.uk/base/path").to_return(status: 200, headers:, body:)
end

def siteimprove_has_summary
  headers = { "content-type" => "application/json" }
  body = {
    "id" => 0,
    "title" => "string",
    "url" => "string",
    "cms_url" => "string",
    "size_bytes" => 0,
    "summary" => {
      "accessibility" => {
        "a_errors" => 0,
        "a_issues" => 0,
        "a_warnings" => 0,
        "aa_errors" => 0,
        "aa_issues" => 0,
        "aa_warnings" => 0,
        "aaa_errors" => 0,
        "aaa_issues" => 0,
        "aaa_warnings" => 0,
      },
      "dci" => {
        "total" => 0,
      },
      "page" => {
        "check_allowed" => true,
        "check_paused" => true,
        "checking_now" => true,
        "first_seen" => "2023-07-06T11:33:44.048Z",
        "last_changed" => "2023-07-06T11:33:44.048Z",
        "last_seen" => "2023-07-06T11:33:44.048Z",
      },
      "policy" => {
        "high_priority_matching_policies" => 0,
        "high_priority_pending_checks" => 0,
        "high_priority_policies" => 0,
        "matching_policies" => 0,
      },
      "quality_assurance" => {
        "broken_links" => 0,
        "misspellings" => 0,
        "potential_misspellings" => 0,
        "referring_pages" => 0,
      },
      "seo" => {
        "errors" => 0,
        "needs_review" => 0,
        "warnings" => 0,
      },
      "seov2" => {
        "content_issues" => 0,
        "technical_issues" => 0,
        "ux_issues" => 0,
      },
    },
    "_links" => {
      "summary" => {
        "page" => {
          "check" => {
            "href" => "string",
          },
        },
        "policy" => {
          "matching_policies" => {
            "href" => "string",
          },
        },
        "quality_assurance" => {
          "broken_links" => {
            "href" => "string",
          },
          "misspellings" => {
            "href" => "string",
          },
          "potential_misspellings" => {
            "href" => "string",
          },
          "referring_pages" => {
            "href" => "string",
          },
          "words_to_review" => {
            "href" => "string",
          },
        },
      },
      "unpublish_impact" => {
        "href" => "string",
      },
      "self" => {
        "href" => "string",
      },
    },
    "_siteimprove" => {
      "accessibility" => {
        "page_report" => {
          "href" => "https://my2.siteimprove.com/Inspector/1054012/Accessibility/Page?pageId=2&impmd=0",
        },
      },
      "policy" => {
        "page_report" => {
          "href" => "https://my2.siteimprove.com/Inspector/1054012/Policy/Page?pageId=2&impmd=0",
        },
      },
      "quality_assurance" => {
        "page_report" => {
          "href" => "https://my2.siteimprove.com/QualityAssurance/1054012/PageDetails/Report?impmd=0&PageId=2",
        },
      },
      "seo" => {
        "page_report" => {
          "href" => "https://my2.siteimprove.com/Inspector/1054012/SeoV2/Page?pageId=2&impmd=0",
        },
      },
    },
  }.to_json
  stub_request(:get, "#{SI_BASE_URI}/sites/1/content/pages/2").to_return(status: 200, headers:, body:)
end

