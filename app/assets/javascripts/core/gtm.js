(function() {

  function filterFormSubmitListner(event) {
    window.dataLayer = window.dataLayer || [];
    var form = event.target;

    var date_range = form.querySelector('input[name="date_range"]:checked').value;
    if(date_range.length > 0) {
      window.dataLayer.push({
        event: 'filter-form',
        field: 'date_range',
        value: date_range
      });
    }

    var search_term = form.querySelector('input[name="search_term"]').value;
    if(search_term.length > 0) {
      window.dataLayer.push({
        event: 'filter-form',
        field: 'search_term',
        value: search_term
      });
    };

    var document_type = form.querySelector('select[name="document_type"]').selectedOptions[0].value;
    if(document_type.length > 0) {
      window.dataLayer.push({
        event: 'filter-form',
        field: 'document_type',
        value: document_type
      });
    }

    var organisation = form.querySelector('select[name="organisation_id"]').selectedOptions[0].text;
    if(organisation.length > 0) {
      window.dataLayer.push({
        event: 'filter-form',
        field: 'organisation',
        value: organisation
      });
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
