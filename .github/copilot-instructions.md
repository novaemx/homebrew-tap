# Copilot Instructions - GitFlow Discipline

Use these rules for every code-change task in this repository:

1. Never edit directly on `main` or `develop`.
2. Start work on `feature/*` or `bugfix/*` from `develop`.
3. Before release publication, always:
   - finish feature/bugfix into `develop`
   - create/finish `release/*` (or `hotfix/*`)
   - backmerge `main` into `develop`
4. Use structured GitFlow commands with JSON output:
   - `gitflow --json status`
   - `gitflow --json start <type> <name>`
   - `gitflow --json finish`
   - `gitflow --json backmerge`
5. Validate before finishing or publishing:
   - `make ci`
   - `make release-ready`
6. Push policy:
   - work branch: `make push-branch`
   - release artifacts: `make push-release`
7. Use `make gitflow-auto` for guided end-to-end automation with checkpoints.
