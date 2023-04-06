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
    this.$selectElem = this.$module.querySelector('select')

    var configOptions = {
      selectElement: this.$selectElem,
      showAllValues: true,
      confirmOnBlur: true,
      preserveNullOptions: true, // https://github.com/alphagov/accessible-autocomplete#null-options
      defaultValue: ''
    }

    configOptions.onConfirm = this.onConfirm.bind(this)

    new accessibleAutocomplete.enhanceSelectElement(configOptions) // eslint-disable-line no-new, new-cap
  }

  AccessibleAutocomplete.prototype.onConfirm = function (label, value, removeDropDown) {
    function escapeHTML (str) {
      return new window.Option(str).innerHTML
    }

    if (this.$selectElem.dataset.trackCategory !== undefined && this.$selectElem.dataset.trackAction !== undefined) {
      track(this.$selectElem.dataset.trackCategory, this.$selectElem.dataset.trackAction, label, this.$selectElem.dataset.trackOptions)
    }
    // This is to compensate for the fact that the accessible-autocomplete library will not
    // update the hidden select if the onConfirm function is supplied
    // https://github.com/alphagov/accessible-autocomplete/issues/322
    if (typeof label !== 'undefined') {
      if (typeof value === 'undefined') {
        value = Array.from(this.$selectElem.querySelectorAll('option'))
          .find(function (option) { return option.innerHTML === escapeHTML(label) })
          .value
      }

      // if removeDropDown we are clearing the selection from outside the component
      if (typeof value !== 'undefined' && typeof removeDropDown === 'undefined') {
        this.$selectElem.value = value
        this.$selectElem.dispatchEvent(new Event('change'))
      }
    }
  }

  function track (category, action, label, options) {
    if (window.GOVUK.analytics && window.GOVUK.analytics.trackEvent) {
      options = options || {}
      options.label = label

      window.GOVUK.analytics.trackEvent(category, action, options)
    }
  }

  Modules.AccessibleAutocomplete = AccessibleAutocomplete
})(window.GOVUK.Modules)
