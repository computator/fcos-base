.SUFFIXES:

BUTANE_CMD ?= podman run --rm -i quay.io/coreos/butane:release
DISTDIR ?= dist
SOURCES := $(wildcard src/*.bu)

targets := $(patsubst src/%.bu,$(DISTDIR)/%$(addprefix _,$(PROVIDER)).ign,$(SOURCES))

.PHONY: build
build: $(targets)
$(targets): | $(DISTDIR)
$(targets): $(DISTDIR)/%$(addprefix _,$(PROVIDER)).ign: src/%.bu
	gpp -D PROVIDER=$(PROVIDER) < $< | $(BUTANE_CMD) --strict > $@

$(DISTDIR):
	mkdir -p $@

.PHONY: clean
clean:
	rm -rf $(DISTDIR)
