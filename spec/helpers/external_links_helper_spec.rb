RSpec.describe ExternalLinksHelper do
  describe "#edit_url_for" do
    context "with a known publishing app" do
      it "generates an expected URL" do
        expect(
          edit_url_for(content_id: "content_id", publishing_app: "whitehall", base_path: "/base-path", document_type: "news_story"),
        ).to eq(
          "#{Plek.external_url_for('whitehall-admin')}/government/admin/by-content-id/content_id",
        )
      end
    end

    context "with publisher" do
      it "generates a link to the Support app" do
        expect(
          edit_url_for(content_id: "content_id", publishing_app: "publisher", base_path: "/base-path", document_type: "news_story"),
        ).to eq(
          "#{Plek.external_url_for('support')}/content_change_request/new",
        )
      end
    end

    context "with content-publisher" do
      it "generates a link to the content-publisher app" do
        expect(
          edit_url_for(
            content_id: "content_id",
            publishing_app: "content-publisher",
            base_path: "/anything",
            document_type: "news_story",
            locale: "fr",
          ),
        ).to eq(
          "#{external_url_for('content-publisher')}/documents/content_id:fr",
        )
      end
    end

    context "with contacts" do
      it "generates a link to the contacts publisher app" do
        expect(
          edit_url_for(
            content_id: "content_id",
            publishing_app: "contacts",
            base_path: "government/organisations/hm-revenue-customs/contact/tax-credits-agent-priority-line",
            document_type: "news_story",
          ),
        ).to eq(
          "#{external_url_for('contacts-admin')}/admin/contacts/tax-credits-agent-priority-line/edit",
        )
      end
    end

    context "with specialist-publisher" do
      it "generates a link to the specialist publisher app with document_type" do
        expect(
          edit_url_for(
            content_id: "spec-pub-id",
            publishing_app: "specialist-publisher",
            base_path: "government/organisations/hm-revenue-customs/contact/tax-credits-agent-priority-line",
            document_type: "service_standard_report",
          ),
        ).to eq(
          "#{external_url_for('specialist-publisher')}/service-standard-reports/spec-pub-id/edit",
        )

        expect(
          edit_url_for(
            content_id: "spec-pub-id",
            publishing_app: "specialist-publisher",
            base_path: "government/organisations/hm-revenue-customs/contact/tax-credits-agent-priority-line",
            document_type: "aaib_report",
          ),
        ).to eq(
          "#{external_url_for('specialist-publisher')}/aaib-reports/spec-pub-id/edit",
        )
      end
    end

    context "with manuals-publisher" do
      it "generates a link to the manuals publisher app for manual itself" do
        expect(
          edit_url_for(
            content_id: "manual-id",
            publishing_app: "manuals-publisher",
            base_path: "/guidance/style-guide",
            document_type: "manual",
          ),
        ).to eq(
          "#{external_url_for('manuals-publisher')}/manuals/manual-id",
        )
      end

      it "generates a link to the manuals publisher app for a manual section" do
        expect(
          edit_url_for(
            content_id: "manual-section-id",
            publishing_app: "manuals-publisher",
            base_path: "/guidance/style-guide/a-to-z-of-gov-uk-style",
            document_type: "manual_section",
            parent_content_id: "manual-id",
          ),
        ).to eq(
          "#{external_url_for('manuals-publisher')}/manuals/manual-id/sections/manual-section-id",
        )
      end
    end

    context "with collections" do
      it "generates a link to the collections publisher app" do
        expect(
          edit_url_for(
            content_id: "coll-pub-id",
            publishing_app: "collections-publisher",
            base_path: "government/organisations/hm-revenue-customs/contact/tax-credits-agent-priority-line",
            document_type: "news_story",
          ),
        ).to eq(
          "#{external_url_for('support')}/content_change_request/new",
        )
      end
    end

    context "with travel advice" do
      it "generates a link to the collections publisher app" do
        expect(
          edit_url_for(
            content_id: "ta-pub-id",
            publishing_app: "travel-advice-publisher",
            base_path: "/foreign-travel-advice/brunei",
            document_type: "news_story",
          ),
        ).to eq(
          "#{external_url_for('travel-advice-publisher')}/admin/countries/brunei",
        )
      end
    end

    context "with an unknown publishing app" do
      it "returns nil" do
        expect(
          edit_url_for(content_id: "content_id", publishing_app: "not-an-app", base_path: "/base-path", document_type: "news_story"),
        ).to eq(
          nil,
        )
      end
    end
  end

  describe "#edit_label_for" do
    context "with a known publishing app" do
      it "generates the expected label" do
        expect(
          edit_label_for(publishing_app: "whitehall"),
        ).to eq(
          "Edit in Whitehall",
        )
      end
    end

    context "with publisher" do
      it "uses the specific label" do
        expect(
          edit_label_for(publishing_app: "publisher"),
        ).to eq(
          "Request a content change in GOV.UK Support",
        )
      end
    end

    context "with content-publisher" do
      it "uses the specific label" do
        expect(
          edit_label_for(publishing_app: "content-publisher"),
        ).to eq(I18n.t(
                  "metrics.show.navigation.edit_link",
                  publishing_app: "Content Publisher",
                ))
      end
    end
  end

  describe "#feedex_url" do
    it "generates URL to feedex with given parameters" do
      host = Plek.external_url_for("support")
      expected_link = "#{host}/anonymous_feedback?from=2018-11-25&to=2018-12-24&paths=%2Fthe%2Fbase%2Fpath"

      expect(feedex_url(
               from: Date.new(2018, 11, 25),
               to: Date.new(2018, 12, 24),
               base_path: "/the/base/path",
             )).to eq(expected_link)
    end

    it "adds document type of homepage when when the page concerned is the homepage" do
      host = Plek.external_url_for("support")
      expected_link = "#{host}/anonymous_feedback?from=2018-11-25&to=2018-12-24&paths=%2F&document_type=homepage"

      expect(feedex_url(
               from: Date.new(2018, 11, 25),
               to: Date.new(2018, 12, 24),
               base_path: "/",
             )).to eq(expected_link)
    end
  end
end
