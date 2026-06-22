# Cidre.app Backend Bridge

- **Command Manifest integration**: Reads `interface/command-manifest.json` to dynamically discover CLI backend metadata.
- **Action plan providers**: Loads actions from `interface/app-actions.json`.
- **JSON result parsing**: Decodes outputs using standard Swift `Codable` structs matching schemas.
- **Blocked outcomes handling**: Parses exit code `8` to display block conditions.
