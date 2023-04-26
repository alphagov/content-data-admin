/* eslint-env jquery */
/* global accessibleAutocomplete */
// = require accessible-autocomplete/dist/accessible-autocomplete.min.js

window.GOVUK = window.GOVUK || {}
window.GOVUK.Modules = window.GOVUK.Modules || {};

(function (Modules) {
  'use strict'

  function AccessibleAutocomplete ($module) {
    this.$module = $module
  }

  AccessibleAutocomplete.prototype.init = function () {
    var configOptions = {
      selectElement: this.$module.querySelector('select'),
      showAllValues: true,
      confirmOnBlur: true,
      preserveNullOptions: true, // https://github.com/alphagov/accessible-autocomplete#null-options
      defaultValue: ''
    }

    new accessibleAutocomplete.enhanceSelectElement(configOptions) // eslint-disable-line no-new, new-cap
  }

  Modules.AccessibleAutocomplete = AccessibleAutocomplete
})(window.GOVUK.Modules)
