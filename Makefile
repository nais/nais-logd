GEM_VERSION_NAIS_LOG_PARSER    = 0.44.0
GEM_VERSION_FLUENT_PLUGIN_NAIS = 0.47.0

IMAGE_TAG         = 0

.PHONY: all docker clean check-vars

all: docker

clean:
	rm -f nais-log-parser-*.gem
	rm -f fluent-plugin-nais-*.gem

check-vars:
	@test $(GITHUB_TOKEN) || echo "GITHUB_TOKEN not set" && test $(GITHUB_TOKEN)
	@test "$(IMAGE_TAG)" != "0" || echo "Warning: Using default image tag: 0"

docker: check-vars nais-log-parser-$(GEM_VERSION_NAIS_LOG_PARSER).gem fluent-plugin-nais-$(GEM_VERSION_FLUENT_PLUGIN_NAIS).gem
	docker build \
	--build-arg GEM_VERSION_NAIS_LOG_PARSER=$(GEM_VERSION_NAIS_LOG_PARSER) \
	--build-arg GEM_VERSION_FLUENT_PLUGIN_NAIS=$(GEM_VERSION_FLUENT_PLUGIN_NAIS) \
	-t ghcr.io/nais/nais-logd/nais-logd:$(IMAGE_TAG) .

nais-log-parser-$(GEM_VERSION_NAIS_LOG_PARSER).gem:
	gem fetch nais-log-parser --version "$(GEM_VERSION_NAIS_LOG_PARSER)" --source "https://x-access-token:$(GITHUB_TOKEN)@rubygems.pkg.github.com/nais"
	test -r nais-log-parser-$(GEM_VERSION_NAIS_LOG_PARSER).gem

fluent-plugin-nais-$(GEM_VERSION_FLUENT_PLUGIN_NAIS).gem:
	gem fetch fluent-plugin-nais --version "$(GEM_VERSION_FLUENT_PLUGIN_NAIS)" --source "https://x-access-token:$(GITHUB_TOKEN)@rubygems.pkg.github.com/nais"
	test -r fluent-plugin-nais-$(GEM_VERSION_FLUENT_PLUGIN_NAIS).gem
