# Helper Gate Enforcement

The privileged helper no longer trusts UI state alone.

Before disk mutation it now checks:

- installer killswitch state
- helper gate state
- boot safety enforcement state
- recovery survival readiness
