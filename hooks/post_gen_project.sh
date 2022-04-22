#! /bin/bash

{%- if cookiecutter.texterifyProjectId != 'NONE' %}
  ./buildStrings
{%- endif %}

{%- if cookiecutter.runXcodeGen == 'y' %}
  xcodegen
{%- endif %}

printf 'all done - enjoy \xf0\x9f\x9a\x80\n'
