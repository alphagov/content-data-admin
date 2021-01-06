function FilterToggle () {
  var toggle = function (action) {
    if (action === 'hide') {
      event.preventDefault()
      document.getElementsByClassName('filters-control--show')[0].classList.remove('filter--hidden')
      document.getElementsByClassName('filters-control--hide')[0].classList.add('filter--hidden')
      document.getElementsByClassName('filter-form')[0].classList.add('filter--hidden')
    } else {
      event.preventDefault()
      document.getElementsByClassName('filters-control--hide')[0].classList.remove('filter--hidden')
      document.getElementsByClassName('filters-control--show')[0].classList.add('filter--hidden')
      document.getElementsByClassName('filter-form')[0].classList.remove('filter--hidden')
    }
  }

  if (document.documentElement.clientWidth < 480) {
    document.getElementsByClassName('filters-control--hide')[0].classList.remove('filter--hidden')
    document.getElementsByClassName('filters-control__wrapper')[0].classList.remove('filter--hidden')
  };

  document.getElementsByClassName('filters-control__link--hide')[0].addEventListener(
    'click', function () { toggle('hide') }, false
  )
  document.getElementsByClassName('filters-control__link--show')[0].addEventListener(
    'click', function () { toggle('show') }, false
  )
}

// Initialise
var $filter = document.querySelector('[data-module="filter-toggle"]')
if ($filter) {
  new FilterToggle() // eslint-disable-line no-new
}
