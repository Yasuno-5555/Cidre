# Boot Safety Gate Enforcement

v0.35.3 turns boot safety evaluation into an actual enforcement boundary.

The installer may not treat an operation as complete unless:

- boot safety gate passes
- finish gate passes
- before-shutdown gate passes
- rollback or failure reporting exists
