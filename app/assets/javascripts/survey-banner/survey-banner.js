!function () {
  var standardBanner = document.querySelector(".banner");
  var surveyBanner = document.querySelector(".survey-banner");
  var surveyBannerHidden = document.cookie
    .split(";")
    .some((item) => item.trim().startsWith("hideContentDataSurveyBanner="));

  function hide(el) {
    el.hidden = true;
    el.style.display = "none";
  }

  function show(el) {
    el.hidden = false;
    el.style.display = "block";
  }

  if (surveyBannerHidden) {
    hide(surveyBanner);
  } else {
    hide(standardBanner);
    show(surveyBanner);
  }

  document.querySelectorAll('[data-hide-survey-banner]').forEach((btn) => {
    btn.addEventListener("click", (e) => {
      e.preventDefault();
      hide(surveyBanner);
      show(standardBanner);
      var expires = new Date();
      expires.setFullYear(expires.getFullYear() + 1);
      document.cookie = `hideContentDataSurveyBanner=; expires=${expires.toUTCString()}; SameSite=strict`;
    });
  });
}();
