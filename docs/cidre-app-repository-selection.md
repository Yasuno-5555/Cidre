# Cidre.app Repository Selection

## Configuration
Cidre.app locates the default workspace in:
* `~/Projects/Cidre`
* `~/Cidre`

## Path Picker and Validation
Users can override the path via the settings view. Setting verification checks for:
* Existence of the directory path.
* `interface/` metadata folders.
* `scripts/` binaries.
* `command-manifest.json` and `app-actions.json` file pointers.

Paths that fail these checks are flagged with explicit validation errors, and saving remains disabled.
