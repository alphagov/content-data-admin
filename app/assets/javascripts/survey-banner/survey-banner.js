(function () {
  var standardBanner = document.querySelector('.banner')
  var surveyBanner = document.querySelector('.survey-banner')
  var surveyBannerHidden = document.cookie
    .split(';')
    .some(function (item) { return item.trim().startsWith('hideContentDataSurveyBanner=') })

  function hide (el) {
    el.hidden = true
    el.style.display = 'none'
  }

  function show (el) {
    el.hidden = false
    el.style.display = 'block'
  }

  if (surveyBannerHidden) {
    hide(surveyBanner)
  } else {
    hide(standardBanner)
    show(surveyBanner)
  }

  function setHideBannerCookie () {
    var expires = new Date()
    expires.setFullYear(expires.getFullYear() + 1)
    document.cookie = 'hideContentDataSurveyBanner=; expires=' + expires.toUTCString() + '; SameSite=strict'
  }

  document.querySelectorAll('[data-show-survey]').forEach(function (btn) {
    btn.addEventListener('click', function (e) {
      setHideBannerCookie()
    })
  })

  document.querySelectorAll('[data-hide-survey-banner]').forEach(function (btn) {
    btn.addEventListener('click', function (e) {
      e.preventDefault()
      hide(surveyBanner)
      show(standardBanner)
      setHideBannerCookie()
    })
  })
})()
