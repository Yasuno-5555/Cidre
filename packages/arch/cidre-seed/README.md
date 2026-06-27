# cidre-seed

This is a meta-package for the Cidre Linux Environment seed target image.
It prepares the system during initial installation to launch the tty1 Out-of-Box Experience (OOBE) helper upon first boot.

## Features
- Enables `NetworkManager.service`
- Enables `cidre-firstboot.service`
- Disables `greetd.service` initially (OOBE completion will re-enable it)
- Locks the `root` password for system safety
