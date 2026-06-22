# Cidre.app SwiftUI Prototype

This is the SwiftUI-based frontend prototype for Cidre (`Cidre.app`).

## Architecture
- **SwiftUI Frontend**: Standard sidebar navigation for macOS.
- **Backend Bridge**: Loads manifests, action plans, and report paths from the `interface/` directory or fixtures.
- **Command Runner**: Mock execution of commands with blocked safety checks for dangerous actions.

## App Bundle

Generate a launchable `.app` bundle with:

```sh
./build-app-bundle.sh --debug
```

Use `--release` when you want a release-configured bundle.

The script writes the bundle into the SwiftPM binary output directory and prints
the resulting `Cidre.app` path.
