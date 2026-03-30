SOLUTIONS := Course0000 Course0001 Course0002 \
	Course0003 Course0004 Course0005 Course0006 \
	Course0007 Course0008 Course0009 Course0010 \
	Course0011 Course0012 Course0013 Course0014 \
	Course0015

.PHONY: help
help: ## Ask for help!
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' \
		$(MAKEFILE_LIST) | sort | \
		awk 'BEGIN {FS = ":.*?## "}; \
		{printf "\033[36m%-30s\033[0m %s\n", \
		$$1, $$2}'

.PHONY: build
build: ## Build all solutions (warnings as errors)
	lake build $(SOLUTIONS) --wfail

.PHONY: clean
clean: ## Clean build artifacts
	lake clean

.PHONY: check
check: build ## Run all checks (alias for build)
