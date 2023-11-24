.SUFFIXES:

BUTANE_CMD ?= podman run --rm -i quay.io/coreos/butane:release
DISTDIR ?= dist
SOURCES := $(wildcard src/*.bu)
ROOT_URL ?= https://raw.githubusercontent.com/computator/fcos-base/

commit_ref := $(shell git rev-parse HEAD)

export DIST_URL ?= $(ROOT_URL)$(commit_ref)/base/$(DISTDIR)/

targets := $(patsubst src/%.bu,$(DISTDIR)/%.ign,$(SOURCES))

.PHONY: build
build: $(targets)
$(targets): | $(DISTDIR)
$(targets): $(DISTDIR)/%.ign: src/%.bu
	envsubst '$$DIST_URL' < $< | $(BUTANE_CMD) --strict > $@

$(DISTDIR):
	mkdir -p $@

.PHONY: clean
clean:
	rm -r $(DISTDIR)
