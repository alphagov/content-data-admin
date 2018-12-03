(function() {

  function filterFormSubmitListner(event) {
    window.dataLayer = window.dataLayer || [];
    var form = event.target;
    var eventName = form.id;

    var dateRangeElement = form.querySelector('input[name="date_range"]:checked');
    if(dateRangeElement && dateRangeElement.value.length > 0) {
      var message = {};
      message[eventName] = { 'date_range': dateRangeElement.value };
      window.dataLayer.push(message);
    }

    var searchTermElement = form.querySelector('input[name="search_term"]');
    if(searchTermElement && searchTermElement.value.length > 0) {
      var message = {};
      message[eventName] = { 'search_term': searchTermElement.value };
      window.dataLayer.push(message);
    };

    var documentTypeElement = form.querySelector('select[name="document_type"]');
    if(documentTypeElement) {
      var documentType = documentTypeElement.selectedOptions[0].value;
      if(documentType.length > 0) {
        var message = {};
        message[eventName] = { 'document_type': documentType };
        window.dataLayer.push(message);
      }
    }

    var organisationElement = form.querySelector('select[name="organisation_id"]')
    if (organisationElement) {
      var organisation = organisationElement.selectedOptions[0].text;
      if(organisation.length > 0) {
        var message = {};
        message[eventName] = { 'organisation': organisation };
        window.dataLayer.push(message);
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
      'viewport-width': viewportWidth
    });
  };

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", init);
  } else {
    init();
  }

})();
