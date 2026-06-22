# Cidre.app Read-Only Safety Policy

## Concept
To guarantee absolute safety during prototype integration, Cidre.app implements a strict read-only execution layer. Destructive write operations are prohibited on the UI layer and verified by the backend policy.

## Implementation Details
* **Destructive Refusal**: Any action flagged with `destructive` or containing write parameters (such as partition table edits, formatting, or resizing) is blocked.
* **Root command Refusal**: Root credentials require privilege elevation which is denied.
* **JSON Constraints**: Only manifest commands designed for standard machine-readable JSON evaluation are executed.
