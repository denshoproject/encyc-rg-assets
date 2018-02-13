PROJECT=encyc
APP=encycrgassets
USER=encyc

SHELL = /bin/bash
DEBIAN_CODENAME := $(shell lsb_release -sc)
DEBIAN_RELEASE := $(shell lsb_release -sr)
VERSION := $(shell cat VERSION)

GIT_SOURCE_URL=https://github.com/densho/encyc-rg-assets

INSTALL_BASE=/opt
INSTALLDIR=$(INSTALL_BASE)/encyc-rg-assets

MEDIA_BASE=/var/www/encycrg
MEDIA_ROOT=$(MEDIA_BASE)/media
STATIC_ROOT=$(MEDIA_BASE)/static

FPM_BRANCH := $(shell git rev-parse --abbrev-ref HEAD | tr -d _ | tr -d -)
FPM_ARCH=amd64
FPM_NAME=$(APP)-$(FPM_BRANCH)
FPM_FILE=$(FPM_NAME)_$(VERSION)_$(FPM_ARCH).deb
FPM_VENDOR=Densho.org
FPM_MAINTAINER=<geoffrey.jost@densho.org>
FPM_DESCRIPTION=Densho Encyclopedia Resource Guide assets
FPM_BASE=opt/encyc-rg-assets


.PHONY: help


help:
	@echo "encyc-rg-assets Install Helper"
	@echo "See: make howto-install"

help-all:
	@echo "install - Do a fresh install"

howto-install:
	@echo "TBD"


install: install-static


install-static:
	@echo ""
	@echo "installing static files ---------------------------------------------"
	-mkdir $(MEDIA_BASE)
	-mkdir $(STATIC_ROOT)
	-cp -R $(INSTALLDIR)/static/img/ $(STATIC_ROOT)/
	-cp -R $(INSTALLDIR)/static/js/ $(STATIC_ROOT)/
	-cp -R $(INSTALLDIR)/static/plugins/ $(STATIC_ROOT)/
	chown -R $(USER).root $(MEDIA_BASE)
	chmod -R 755 $(MEDIA_BASE)

clean: clean-static

clean-static:
	-rm -Rf $(STATIC_ROOT)/img/
	-rm -Rf $(STATIC_ROOT)/js/
	-rm -Rf $(STATIC_ROOT)/plugins/


# http://fpm.readthedocs.io/en/latest/
# https://stackoverflow.com/questions/32094205/set-a-custom-install-directory-when-making-a-deb-package-with-fpm
# https://brejoc.com/tag/fpm/
deb:
	@echo ""
	@echo "DEB packaging ----------------------------------------------------------"
	-rm -Rf $(FPM_FILE)
	fpm   \
	--verbose   \
	--input-type dir   \
	--output-type deb   \
	--name $(FPM_NAME)   \
	--version $(VERSION)   \
	--package $(FPM_FILE)   \
	--url "$(GIT_SOURCE_URL)"   \
	--vendor "$(FPM_VENDOR)"   \
	--maintainer "$(FPM_MAINTAINER)"   \
	--description "$(FPM_DESCRIPTION)"   \
	--chdir $(INSTALLDIR)   \
	media=var/www/encycrg   \
	static=var/www/encycrg   \
	.git=$(FPM_BASE)   \
	.gitignore=$(FPM_BASE)   \
	media=$(FPM_BASE)   \
	static=$(FPM_BASE)   \
	INSTALL=$(FPM_BASE)   \
	Makefile=$(FPM_BASE)   \
	README=$(FPM_BASE)   \
	VERSION=$(FPM_BASE)
