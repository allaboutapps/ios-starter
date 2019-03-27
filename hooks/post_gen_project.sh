#! /bin/bash

{%- if cookiecutter.googleSheetId != 'NONE' %}
  echo "Fetching strings"
  ./buildStrings
{%- endif %}

{%- if cookiecutter.runCarthage == 'y' %}
  carthage update --platform ios --cache-builds
{%- endif %}

{%- if cookiecutter.runXcodeGen == 'y' %}
  xcodegen
  xed .
{%- endif %}

printf 'all done - enjoy \xf0\x9f\x9a\x80\n'
