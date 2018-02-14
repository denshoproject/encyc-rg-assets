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

DEB_BRANCH := $(shell git rev-parse --abbrev-ref HEAD | tr -d _ | tr -d -)
DEB_ARCH=amd64
DEB_NAME=$(APP)-$(DEB_BRANCH)
DEB_FILE=$(DEB_NAME)_$(VERSION)_$(DEB_ARCH).deb
DEB_VENDOR=Densho.org
DEB_MAINTAINER=<geoffrey.jost@densho.org>
DEB_DESCRIPTION=Densho Encyclopedia Resource Guide assets
DEB_BASE=opt/encyc-rg-assets


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
	-rm -Rf $(DEB_FILE)
	fpm   \
	--verbose   \
	--input-type dir   \
	--output-type deb   \
	--name $(DEB_NAME)   \
	--version $(VERSION)   \
	--package $(DEB_FILE)   \
	--url "$(GIT_SOURCE_URL)"   \
	--vendor "$(DEB_VENDOR)"   \
	--maintainer "$(DEB_MAINTAINER)"   \
	--description "$(DEB_DESCRIPTION)"   \
	--chdir $(INSTALLDIR)   \
	media=var/www/encycrg   \
	static=var/www/encycrg   \
	.git=$(DEB_BASE)   \
	.gitignore=$(DEB_BASE)   \
	media=$(DEB_BASE)   \
	static=$(DEB_BASE)   \
	INSTALL=$(DEB_BASE)   \
	Makefile=$(DEB_BASE)   \
	README=$(DEB_BASE)   \
	VERSION=$(DEB_BASE)
