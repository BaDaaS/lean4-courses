TARGETS := Course0000 Course0001 Course0002 \
	Course0003 Course0004 Course0005 Course0006 \
	Course0007 Course0008 Course0009 Course0010 \
	Course0011 Course0012 Course0013 Course0014 \
	Course0015 Course0016 Course0017 Course0018 \
	Course0019 Course0020 Course0021 Course0022 \
	Course0023 Course0024 Course0025 Course0026 \
	Course0027 Course0028 Course0029 Course0030 \
	Course0031 StandaloneSolutions

.PHONY: help
help: ## Ask for help!
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' \
		$(MAKEFILE_LIST) | sort | \
		awk 'BEGIN {FS = ":.*?## "}; \
		{printf "\033[36m%-30s\033[0m %s\n", \
		$$1, $$2}'

.PHONY: build
build: ## Build all solutions and examples (warnings as errors)
	lake build $(TARGETS) --wfail

.PHONY: clean
clean: ## Clean build artifacts
	lake clean

.PHONY: check
check: build ## Run all checks (alias for build)

.PHONY: inject-snippets
inject-snippets: ## Inject .lean code into READMEs
	.github/scripts/inject-snippets.sh

.PHONY: check-snippets
check-snippets: ## Verify READMEs match .lean sources
	.github/scripts/inject-snippets.sh --check

.PHONY: setup-hooks
setup-hooks: ## Configure git to use project hooks
	git config core.hooksPath .github/hooks

.PHONY: lint-shell
lint-shell: ## Lint shell scripts using shellcheck
	shellcheck .github/scripts/*.sh
