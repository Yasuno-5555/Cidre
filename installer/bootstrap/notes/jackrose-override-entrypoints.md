# Jackrose Override Entrypoints

Jackrose overrides installer metadata by exporting parameters before launching the bootstrap script:

```sh
export INSTALLER_DATA="http://127.0.0.1:8765/asahi-installer-data.jackrose.dev.json"
export REPO_BASE="http://127.0.0.1:8765"
```
- **Local Mocks**: Served using `serve-installer-data` on localhost.
- **Hosted Releases**: Served using GitHub Releases URL schemas.
