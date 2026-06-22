# Noninteractive Mode

All major commands are designed to accept a `--non-interactive` flag to suppress any prompt behavior.
When prompts or confirmations are missed, the command exits with code `8` (Blocked) and returns structured JSON detail of the missing confirmations.
