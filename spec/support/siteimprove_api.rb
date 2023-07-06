SI_BASE_URI = "https://api.eu.siteimprove.com/v2".freeze

def siteimprove_is_unauthorized
  body = {}.to_json
  stub_request(:get, "#{SI_BASE_URI}/sites/1/content/pages?url=https://www.gov.uk/base/path").to_return(status: 401, body:)
end

def siteimprove_has_no_matching_pages; end

def siteimprove_has_matching_pages
  body = {
    "items" => [
      {
        "id" => 2,
        "title" => "Matched Page",
        "url" => "https =>//www.gov.uk/base/path",
        "_links" => {
          "details" => {
            "href" => "https =>//www.gov.uk/base/path",
          },
        },
      },
      {
        "id" => 3,
        "title" => "Close Match Page",
        "url" => "https =>//www.gov.uk/base/path/subpage",
        "_links" => {
          "details" => {
            "href" => "https =>//www.gov.uk/base/path/subpage",
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
  stub_request(:get, "#{SI_BASE_URI}/sites/1/content/pages?url=https://www.gov.uk/base/path").to_return(status: 200, body:)
end

def siteimprove_has_imperfect_matching_pages; end

def siteimprove_has_no_summary; end

def siteimprove_has_summary; end

def siteimprove_has_no_matching_policy_issues; end

def siteimprove_has_matching_policy_issues; end

def siteimprove_has_no_policies; end

def siteimprove_has_policies; end

def siteimprove_has_no_accessibility_issues; end

def siteimprove_has_potential_accessibility_issues; end

def siteimprove_has_confirmed_accessibility_issues; end
