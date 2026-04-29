SHELL := bash

VERSION ?= $(shell tr -d '[:space:]' < VERSION)
CURRENT_BRANCH := $(shell git branch --show-current 2>/dev/null)
CURRENT_TAG := v$(VERSION)
PUSH_BRANCH ?= $(CURRENT_BRANCH)

.PHONY: help wizard wizard-auto gitflow-auto flow-status flow-finish-work flow-start-release flow-finish-release flow-backmerge test validate preflight preflight-publish publish-check ci push-ready release-ready push-branch push-release push-all

help:
	@echo "Tap Wizard"
	@echo "Branch: $(CURRENT_BRANCH)"
	@echo "Version: $(VERSION)"
	@echo ""
	@echo "Step 1 (daily validation):"
	@echo "  make test          - Run unit/integration/e2e script tests"
	@echo "  make validate      - Validate all formulas in Formula/"
	@echo "  make ci            - Run test + validate"
	@echo "  make push-ready    - Safe checks before pushing feature/develop"
	@echo ""
	@echo "Step 2 (release preflight local):"
	@echo "  make preflight     - Local preflight (does not require remote tag)"
	@echo "  make release-ready - Run ci + local preflight"
	@echo ""
	@echo "Step 3 (publish strict):"
	@echo "  make preflight-publish - Strict publish guardrails (requires remote tag)"
	@echo "  make publish-check     - Full publish checks (validate + strict preflight)"
	@echo ""
	@echo "Step 4 (update GitHub):"
	@echo "  make push-branch       - Push current branch to origin"
	@echo "  make push-release      - Push main + develop + current tag"
	@echo "  make push-all          - Auto-push branch or release set by branch type"
	@echo ""
	@echo "Automation:"
	@echo "  make wizard-auto       - Interactive phase-by-phase runner"
	@echo ""
	@echo "GitFlow Intelligence:"
	@echo "  make flow-status       - Show gitflow status in JSON"
	@echo "  make flow-finish-work  - Finish current feature/bugfix"
	@echo "  make flow-start-release - Start release from develop using VERSION"
	@echo "  make flow-finish-release - Finish current release/hotfix"
	@echo "  make flow-backmerge    - Backmerge main into develop"
	@echo "  make gitflow-auto      - Guided end-to-end gitflow automation"

wizard: help

wizard-auto:
	bash scripts/gitflow_auto.sh

gitflow-auto:
	bash scripts/gitflow_auto.sh

flow-status:
	gitflow --json status

flow-finish-work:
	gitflow --json finish

flow-start-release:
	gitflow --json start release "$(VERSION)"

flow-finish-release:
	gitflow --json finish

flow-backmerge:
	gitflow --json backmerge

test:
	bash tests/run_tests.sh

validate:
	bash scripts/validate_formulas.sh

preflight:
	@echo "Running local preflight for $(CURRENT_TAG) on $(CURRENT_BRANCH)"
	@if git rev-parse --verify "refs/tags/$(CURRENT_TAG)^{commit}" >/dev/null 2>&1; then \
		echo "Local tag exists: $(CURRENT_TAG)"; \
	else \
		echo "Local tag missing: $(CURRENT_TAG)"; \
		echo "Create it when release is ready: git tag $(CURRENT_TAG)"; \
	fi
	@echo "Local preflight completed."

preflight-publish:
	bash scripts/publish_preflight.sh --version "$(VERSION)"

publish-check:
	bash scripts/publish_tap.sh --version "$(VERSION)"

ci: test validate

push-ready: ci

release-ready: ci preflight

push-branch:
	git push -u origin "$(PUSH_BRANCH)"

push-release:
	git push origin main develop
	@if git rev-parse --verify "refs/tags/$(CURRENT_TAG)^{commit}" >/dev/null 2>&1; then \
		git push origin "$(CURRENT_TAG)"; \
	else \
		echo "Tag $(CURRENT_TAG) not found locally. Skipping tag push."; \
	fi

push-all:
	@if [[ "$(CURRENT_BRANCH)" == "main" || "$(CURRENT_BRANCH)" == release/* || "$(CURRENT_BRANCH)" == hotfix/* ]]; then \
		$(MAKE) push-release; \
	else \
		$(MAKE) push-branch; \
	fi