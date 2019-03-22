# iOS Project Template 📱
Project template for our iOS apps

## Steps

1. Run `cookiecutter --checkout gh-automatic-configuration https://github.com/allaboutapps/ios-project-template.git`. You'll be asked for project name, team details and bundle identifier details. `cookiecutter` will create all files needed from the template on `github`.
2. `xcodegen` will run automatically and generate the `Xcode` project file.
3. Afterwards ``carthage update --platform ios --cache-build` will install/update all needed dependencies.
4. Done - Build and run your new project!
