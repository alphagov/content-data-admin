(function() {

  function filterFormSubmitListner(event) {
    window.dataLayer = window.dataLayer || [];
    var form = event.target;
    var eventName = form.id;

    var dateRangeTag = form.querySelector('input[name="date_range"]:checked');
    if(dateRangeTag && dateRangeTag.value.length > 0) {
      window.dataLayer.push({
        event: eventName,
        field: 'dateRange',
        value: dateRangeTag.value
      });
    }

    var searchTermTag = form.querySelector('input[name="search_term"]');
    if(searchTermTag && searchTermTag.value.length > 0) {
      window.dataLayer.push({
        event: eventName,
        field: 'searchTerm',
        value: searchTerm.value
      });
    };

    var documentTypeTag = form.querySelector('select[name="document_type"]');
    if(documentTypeTag) {
      var documentType = documentTypeTag.selectedOptions[0].value;
      if(documentType.length > 0) {
        window.dataLayer.push({
          event: eventName,
          field: 'documentType',
          value: documentType
        });
      }
    }

    var organisationTag = form.querySelector('select[name="organisation_id"]')
    if (organisationTag) {
      var organisation = organisationTag.selectedOptions[0].text;
      if(organisation.length > 0) {
        window.dataLayer.push({
          event: eventName,
          field: 'organisation',
          value: organisation
        });
      }
    }

  };

  function init() {
    var form = document.getElementById("filter-form")
    if(form != null) {
      form.addEventListener("submit", filterFormSubmitListner, false);
    }

    window.dataLayer = window.dataLayer || [];
    var viewportWidth = Math.max(document.documentElement.clientWidth, window.innerWidth || 0);
    dataLayer.push({
      event: 'viewport-width',
      value: viewportWidth
    });
  };

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", init);
  } else {
    init();
  }

})();
