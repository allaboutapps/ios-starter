#! /bin/bash

xcodegen
carthage update --platform ios --cache-builds
cd '{{cookiecutter.projectName}}-ios'
xed .

printf 'all done - enjoy \xf0\x9f\x9a\x80\n'