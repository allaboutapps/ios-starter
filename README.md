# iOS Starter 📱

`cookiecutter gh:allaboutapps/ios-starter`

## Installation

Install [Cookiecutter](https://cookiecutter.readthedocs.io/en/latest/installation.html) and [XcodeGen](https://github.com/yonaskolb/XcodeGen#installing). 

```
brew install cookiecutter
brew install xcodegen
```

## Steps

1. Run `cookiecutter gh:allaboutapps/ios-starter.git`.
2. You'll be asked for project name, team details and bundle identifier details. `cookiecutter` will create all files needed from the template on `github`.
3. `xcodegen` will run automatically and generate the `Xcode` project file.
4. Afterwards `carthage update --platform ios --cache-build` will install/update all needed dependencies.
5. Xcode launches your new project.
6. 🚀
