# iOS Starter 📱

Xcode 15.x with Swift Package Manager dependencies.

`cookiecutter gh:allaboutapps/ios-starter`

## Installation

Install [Cookiecutter](https://cookiecutter.readthedocs.io/en/latest/installation.html), [XcodeGen](https://github.com/yonaskolb/XcodeGen#installing) and [SwiftGen](https://github.com/SwiftGen/SwiftGen#installation).

```
brew install cookiecutter
brew install xcodegen
brew install swiftgen
```

#### Texterify Setup

[Texterify](https://github.com/chrztoph/texterify) is an open source localization management system, which can be hosted on your own server or run locally.
To integrate Texterify in your project, you need to install the [Texterify CLI](https://github.com/chrztoph/texterify-cli):

```
npm install -g texterify
```

Follow the configuration steps described in the [documentation](https://github.com/chrztoph/texterify-cli#configuration).

## Steps

1. Run `cookiecutter gh:allaboutapps/ios-starter`.
2. You'll be asked for project name, team details and bundle identifier details. If you don't have the localization tool installed, skip the `texterify` parameters. `cookiecutter` will create all files needed from the template on `github`.
3. `xcodegen` will run automatically and generate the `Xcode` project file.
4. Xcode launches your new project.
5. 🚀
