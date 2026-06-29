# jackrose-seed

This is a meta-package for the Jackrose Linux Environment seed target image.
It prepares the system during initial installation to launch the tty1 Out-of-Box Experience (OOBE) helper upon first boot.

## Features
- Enables `NetworkManager.service`
- Enables `jackrose-firstboot.service`
- Disables `greetd.service` initially (OOBE completion will re-enable it)
- Locks the `root` password for system safety
