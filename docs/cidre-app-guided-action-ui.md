# Cidre.app Guided Action UI

## Purpose
The purpose of the Guided Action UI in Cidre.app is to transition the application shell from a read-only prototype to an interactive interface where users can select repositories, view action lists, trigger safe read-only operations, and track command history.

## Dashboard
Displays:
* Selected repository path and verification status.
* Live statuses of app readiness.
* Live status of the interface doctor checklist.
* Action buttons to manually trigger diagnostic updates.

## Install/Uninstall Actions
* Displays categorized action paths discovered from the interface layer metadata.
* Safely executes read-only preflight commands.
* Explicitly lists destructive commands (like disk partitioning or boot modification) as **blocked**, providing explanations for safety policy boundaries.

## Repair Actions
* Shows recovery lists, rescue status previews, and available system indicators.

## Reports
* Embeds a dedicated markdown detail renderer with clipboard copying utility.

## Logs
* Presents dynamic history of actions executed by the user.

## Settings
* Repository Path Picker, live read-only toggle, and logging configurations.
