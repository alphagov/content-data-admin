SI_BASE_URI = "https://api.eu.siteimprove.com/v2".freeze

def siteimprove_is_unauthorized
  headers = { "content-type" => "application/json" }
  body = {}.to_json
  stub_request(:get, "#{SI_BASE_URI}/sites/1/content/pages?url=https://www.gov.uk/base/path").to_return(status: 401, headers:, body:)
end

def siteimprove_has_no_matching_pages
  headers = { "content-type" => "application/json" }
  body = {
    "items" => [],
    "total_items" => 0,
    "total_pages" => 0,
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

def siteimprove_has_imperfectly_matching_pages
  headers = { "content-type" => "application/json" }
  body = {
    "items" => [
      {
        "id" => 4,
        "title" => "Close Matched Page 2",
        "url" => "https://www.gov.uk/base/path/values",
        "_links" => {
          "details" => {
            "href" => "https://www.gov.uk/base/path/values",
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

def siteimprove_has_no_summary; end

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

def siteimprove_has_no_matching_policy_issues
  headers = { "content-type" => "application/json" }
  body = {
    "items" => [],
    "total_items" => 0,
    "total_pages" => 0,
    "links" => {
      "self" => {
        "href" => "string",
      },
    },
  }.to_json
  stub_request(:get, "#{SI_BASE_URI}/sites/1/policy/pages/2/matching_policies").to_return(status: 200, headers:, body:)
end

def siteimprove_has_matching_policy_issues
  headers = { "content-type" => "application/json" }
  body = {
    "items" => [
      {
        "id" => 10,
        "detected_date" => "2023-07-06T11:10:12.822Z",
        "policy_category" => "content",
        "policy_name" => "GDS001 - First Style Issue",
        "policy_priority" => "medium",
        "_links" => {
          "matches" => {
            "href" => "string",
          },
        },
      },
      {
        "id" => 11,
        "detected_date" => "2023-07-06T11:10:12.822Z",
        "policy_category" => "content",
        "policy_name" => "GDSA021 - First Accessibility Issue",
        "policy_priority" => "high",
        "_links" => {
          "matches" => {
            "href" => "string",
          },
        },
      },
    ],
    "total_items" => 2,
    "total_pages" => 1,
    "links" => {
      "self" => {
        "href" => "string",
      },
    },
  }.to_json
  stub_request(:get, "#{SI_BASE_URI}/sites/1/policy/pages/2/matching_policies").to_return(status: 200, headers:, body:)
end

def siteimprove_has_no_policies
  headers = { "content-type" => "application/json" }
  body = {
    "items" => [],
    "total_items" => 0,
    "total_pages" => 0,
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
  stub_request(:get, "#{SI_BASE_URI}/sites/1/policy/policies?page_size=500").to_return(status: 200, headers:, body:)
end

def siteimprove_has_policies
  headers = { "content-type" => "application/json" }
  body = {
    "items" => [
      {
        "id" => 10,
        "name" => "GDS001 - Style Issue",
        "all_sites" => true,
        "category" => "content",
        "created_by" => "string",
        "created_date" => "2023-07-06T11:16:06.621Z",
        "edited_by" => "string",
        "last_edited" => "2023-07-06T11:16:06.621Z",
        "matches" => 0,
        "note" => "Description of GDS001",
        "pending_execution" => true,
        "priority" => "none",
        "sites" => 0,
        "_links" => {
          "sites" => {
            "href" => "string",
          },
        },
      },
      {
        "id" => 11,
        "name" => "GDSA021 - Accessibility Issue",
        "all_sites" => true,
        "category" => "content",
        "created_by" => "string",
        "created_date" => "2023-07-06T11:16:06.621Z",
        "edited_by" => "string",
        "last_edited" => "2023-07-06T11:16:06.621Z",
        "matches" => 0,
        "note" => "Description of GDSA021",
        "pending_execution" => true,
        "priority" => "none",
        "sites" => 0,
        "_links" => {
          "sites" => {
            "href" => "string",
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
  stub_request(:get, "#{SI_BASE_URI}/sites/1/policy/policies?page_size=500").to_return(status: 200, headers:, body:)
end

def siteimprove_has_misspellings
  headers = { "content-type" => "application/json" }
  body = {
    "items" => [
      {
        "id" => 0,
        "suggestions" => %w[fish],
        "word" => "phish",
      },
    ],
    "total_items" => 0,
    "total_pages" => 0,
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
  stub_request(:get, "#{SI_BASE_URI}/sites/1/quality_assurance/spelling/pages/2/misspellings").to_return(status: 200, headers:, body:)
end

def siteimprove_has_no_misspellings
  headers = { "content-type" => "application/json" }
  body = {
    "items" => [],
    "total_items" => 0,
    "total_pages" => 0,
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
  stub_request(:get, "#{SI_BASE_URI}/sites/1/quality_assurance/spelling/pages/2/misspellings").to_return(status: 200, headers:, body:)
end

def siteimprove_has_no_broken_links
  headers = { "content-type" => "application/json" }
  body = {
    "items" => [
      {
        "id" => 0,
        "url" => "string",
        "checking_now" => true,
        "last_checked" => "2023-07-06T11:49:30.532Z",
        "link_status_changed" => "2023-07-06T11:49:30.532Z",
        "message" => "string",
      },
    ],
    "total_items" => 0,
    "total_pages" => 0,
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
  stub_request(:get, "#{SI_BASE_URI}/sites/1/quality_assurance/links/pages_with_broken_links/2/broken_links").to_return(status: 200, headers:, body:)
end
