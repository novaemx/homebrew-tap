# Homebrew Tap

This repository is the shared tap for one or more formulas.

## Install From Tap

```bash
brew tap novaemx/tap
brew install gitflow-helper
```

## Add Another Formula

1. Add a new Ruby formula file in `Formula/`.
2. Ensure each formula includes `version`, `url`, and `sha256`.
3. Run local validation:

```bash
bash scripts/validate_formulas.sh
```

## Validate And Publish Updates

Before publish, run:

```bash
bash scripts/publish_tap.sh --version <x.y.z>
```

This checks:

- Formula consistency across all formulas in `Formula/`
- Local release tag exists (`v<x.y.z>`)
- Remote release tag exists in `origin`
- Tag commit is reachable from `origin/main`
- Branch context is publish-safe (`main`, `release/*`, or `hotfix/*`)

Then publish:

```bash
git push origin main
git push origin v<x.y.z>
```

This repository uses a local-only release flow. Validation and publish steps are executed via local scripts and `make` targets.

## Makefile Shortcuts

```bash
make test
make validate
make preflight
make preflight-publish
make publish-check
make push-ready
make release-ready
make push-branch
make push-release
make push-all
make wizard-auto
make flow-status
make flow-finish-work
make flow-start-release
make flow-finish-release
make flow-backmerge
make gitflow-auto
```

`make wizard-auto` runs the full guided GitFlow process end-to-end (feature/bugfix finish, release start/finish, backmerge, push) and asks whether to continue after each successful phase.

## GitFlow End-To-End

Use `make gitflow-auto` (or `make wizard-auto`) to run an interactive GitFlow sequence from feature work to release publication:

1. Runs CI checks.
	- If pending changes exist, it auto-creates a feature branch when needed and creates a checkpoint commit.
2. Finishes feature/bugfix branch when applicable.
3. Starts release branch from `develop` using `VERSION`.
	- If the tag already exists, it automatically uses the next patch version.
4. Runs release validation.
5. If `main` is ahead of `develop`, it performs backmerge automatically before finish.
6. Finishes release/hotfix.
7. Executes backmerge and pushes release artifacts.
