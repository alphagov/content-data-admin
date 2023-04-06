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
      selectElement: document.getElementById(this.$selectElem.attr('id')),
      showAllValues: true,
      confirmOnBlur: true,
      preserveNullOptions: true, // https://github.com/alphagov/accessible-autocomplete#null-options
      defaultValue: ''
    }

    configOptions.onConfirm = this.onConfirm.bind(this)

    new accessibleAutocomplete.enhanceSelectElement(configOptions) // eslint-disable-line no-new, new-cap
    // attach the onConfirm function to data attr, to call it in finder-frontend when clearing facet tags
    this.$selectElem.data('onconfirm', this.onConfirm.bind(this))
  }

  AccessibleAutocomplete.prototype.onConfirm = function (label, value, removeDropDown) {
    function escapeHTML (str) {
      return new window.Option(str).innerHTML
    }

    if (this.$selectElem.data('track-category') !== undefined && this.$selectElem.data('track-action') !== undefined) {
      track(this.$selectElem.data('track-category'), this.$selectElem.data('track-action'), label, this.$selectElem.data('track-options'))
    }
    // This is to compensate for the fact that the accessible-autocomplete library will not
    // update the hidden select if the onConfirm function is supplied
    // https://github.com/alphagov/accessible-autocomplete/issues/322
    if (typeof label !== 'undefined') {
      if (typeof value === 'undefined') {
        value = this.$selectElem.children('option').filter(function () { return $(this).html() === escapeHTML(label) }).val()
      }

      if (typeof value !== 'undefined') {
        var $option = this.$selectElem.find('option[value=\'' + value + '\']')
        // if removeDropDown we are clearing the selection from outside the component
        var selectState = typeof removeDropDown === 'undefined'
        $option.prop('selected', selectState)
        this.$selectElem.change()
      }

      // used to clear the autocomplete when clicking on a facet tag in finder-frontend
      // very brittle but menu visibility is determined by autocomplete after this function is called
      // setting autocomplete val to '' causes menu to appear, we don't want that, this solves it
      // ideally will rewrite autocomplete to have better hooks in future
      if (removeDropDown) {
        this.$selectElem.closest('.app-c-accessible-autocomplete').addClass('app-c-accessible-autocomplete--hide-menu')
        setTimeout(function () {
          $('.autocomplete__menu').remove() // this element is recreated every time the user starts typing
          this.$selectElem.closest('.app-c-accessible-autocomplete').removeClass('app-c-accessible-autocomplete--hide-menu')
        }, 100)
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
