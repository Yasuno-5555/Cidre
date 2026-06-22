# Pre/Post Disk Diff

Every future disk-changing install test must capture:

1. a before snapshot
2. an after snapshot
3. a diff classification

The diff must separate:

- allowed non-protected target changes
- unexpected protected partition changes

Protected changes are always blocking during incident containment.
