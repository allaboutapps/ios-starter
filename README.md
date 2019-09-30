# iOS Starter 📱

`cookiecutter gh:allaboutapps/ios-starter`

## Installation

Install [Cookiecutter](https://cookiecutter.readthedocs.io/en/latest/installation.html) and [XcodeGen](https://github.com/yonaskolb/XcodeGen#installing). 

```
brew install cookiecutter
brew install xcodegen
```

#### Optional step for _all about apps internal use_
Install the latest version of our internal Google Sheets localization tool and [builder](https://rubygems.org/gems/builder).

```
npm install -g @aaa/google-docs-i18n-strings
gem install builder
```

## Steps

1. Run `cookiecutter gh:allaboutapps/ios-starter --checkout spm`.
2. You'll be asked for project name, team details and bundle identifier details. If you don't have the localization tool installed, skip the `googleSheetId` parameter. `cookiecutter` will create all files needed from the template on `github`.
3. `xcodegen` will run automatically and generate the `Xcode` project file.
4. Xcode launches your new project.
5. 🚀
