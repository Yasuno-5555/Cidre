# Jackrose Image Layout

The prototype Jackrose image should treat ALARM minimal as the base and add a small downstream overlay.

## Expected Layout

```text
/usr/lib/jackrose/
  jackrose-firstboot-root
  jackrose-seed
  jackrose-seed-verify
  jackrose-seed-import
  jackrose-resume
  jackrose-doctor
  jackrose-recovery
  jackrose-preinstall
  jackrose-installer

/etc/systemd/system/
  jackrose-firstboot-root.service
  multi-user.target.wants/jackrose-firstboot-root.service

/var/lib/jackrose/
  seed/
  resume/
  firstboot-root/
```

## Notes

- v0.15.0 turns the overlay skeleton into a prototype artifact source
- root autologin is example-only and must not be enabled by default
- seed/resume tooling should be present in the image even before the desktop layer is complete
