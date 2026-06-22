# Wizard Gate Enforcement

Wizard transitions are now policy checked.

Examples:

- `disk-planning -> install-execution` blocks while killswitch containment is active
- `install-execution -> finish` blocks until boot safety passes
- `finish -> shutdown` blocks until before-shutdown gate passes
