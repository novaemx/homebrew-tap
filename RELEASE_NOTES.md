# Release 0.5.43

**Date:** 2026-04-29

## What's New

- Added shared tap automation to support current and future formulas in `Formula/`.
- Added CI workflow to run tests and formula validation on push/PR.
- Added publish workflow to validate release context and publish GitHub release metadata on tags.
- Added reusable scripts for formula validation and publish preflight checks.
- Added Makefile to run validations and release checks with simple commands.

## Improvements

- VERSION now matches formula versioning (`0.5.43`) for consistent release metadata.
- README updated with the operational flow for validate/publish.

## Validation

- Unit, integration, and e2e script tests pass.
- Formula validation pass confirmed for `Formula/gitflow-helper.rb`.

