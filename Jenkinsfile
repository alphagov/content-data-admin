#!/usr/bin/env groovy

library("govuk")

node("postgresql-9.6") {
  govuk.buildProject(
    beforeTest: { sh("yarn install") },
    sassLint: false,
  )
}
