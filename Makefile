SHELL := bash

VERSION ?= $(shell tr -d '[:space:]' < VERSION)

.PHONY: help test validate preflight publish-check ci push-ready release-ready

help:
	@echo "Targets:"
	@echo "  make test          - Run unit/integration/e2e script tests"
	@echo "  make validate      - Validate all formulas in Formula/"
	@echo "  make preflight     - Validate release/tag/branch publish guardrails"
	@echo "  make publish-check - Run full publish checks (validate + preflight)"
	@echo "  make ci            - Run test + validate"
	@echo "  make push-ready    - Run checks required before pushing this branch"
	@echo "  make release-ready - Run ci + publish-check"

test:
	bash tests/run_tests.sh

validate:
	bash scripts/validate_formulas.sh

preflight:
	bash scripts/publish_preflight.sh --version "$(VERSION)"

publish-check:
	bash scripts/publish_tap.sh --version "$(VERSION)"

ci: test validate

push-ready: ci

release-ready: ci publish-check