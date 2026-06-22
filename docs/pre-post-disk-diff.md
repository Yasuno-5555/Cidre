# Pre/Post Disk Diff

Every future disk-changing install test must capture:

1. a before snapshot
2. an after snapshot
3. a diff classification

The diff must separate:

- allowed non-protected target changes
- unexpected protected partition changes

Examples:

- allowed: Cidre target partition created or removed
- blocked: Apple recovery missing or startup container changed

Protected changes are always blocking during incident containment.
