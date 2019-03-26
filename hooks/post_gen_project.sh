#! /bin/bash

echo "Fetching strings"
./buildStrings


if {{cookiecutter.generateXcodeProject}} ;then
  xcodegen
fi


if {{cookiecutter.runInitiallyCarthage}} ;then
  carthage update --platform ios --cache-builds
fi

pwd

if {{cookiecutter.generateXcodeProject}} ;then
  xed .
fi

printf 'all done - enjoy \xf0\x9f\x9a\x80\n'
