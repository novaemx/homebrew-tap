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

GitHub Actions runs:

- `.github/workflows/validate.yml` on pushes/PRs for validation and tests
- `.github/workflows/publish.yml` on release tags (or manual dispatch) to validate and publish a GitHub release entry

## Makefile Shortcuts

```bash
make test
make validate
make preflight
make publish-check
make release-ready
```
