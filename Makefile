PROJECT=encyc
APP=encycrgassets
USER=encyc
SHELL = /bin/bash

APP_VERSION := $(shell cat VERSION)
GIT_SOURCE_URL=https://github.com/densho/encyc-rg-assets

# Release name e.g. jessie
DEBIAN_CODENAME := $(shell lsb_release -sc)
# Release numbers e.g. 8.10
DEBIAN_RELEASE := $(shell lsb_release -sr)
# Sortable major version tag e.g. deb8
DEBIAN_RELEASE_TAG = deb$(shell lsb_release -sr | cut -c1)

INSTALL_BASE=/opt
INSTALLDIR=$(INSTALL_BASE)/encyc-rg-assets

MEDIA_BASE=/var/www/encycrg
MEDIA_ROOT=$(MEDIA_BASE)/media
STATIC_ROOT=$(MEDIA_BASE)/static

DEB_BRANCH := $(shell git rev-parse --abbrev-ref HEAD | tr -d _ | tr -d -)
DEB_ARCH=amd64
DEB_NAME_JESSIE=$(APP)-$(DEB_BRANCH)
DEB_NAME_STRETCH=$(APP)-$(DEB_BRANCH)
# Application version, separator (~), Debian release tag e.g. deb8
# Release tag used because sortable and follows Debian project usage.
DEB_VERSION_JESSIE=$(APP_VERSION)~deb8
DEB_VERSION_STRETCH=$(APP_VERSION)~deb9
DEB_FILE_JESSIE=$(DEB_NAME_JESSIE)_$(DEB_VERSION_JESSIE)_$(DEB_ARCH).deb
DEB_FILE_STRETCH=$(DEB_NAME_STRETCH)_$(DEB_VERSION_STRETCH)_$(DEB_ARCH).deb
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
deb: deb-jessie deb-stretch

# deb-jessie and deb-stretch are identical.
deb-jessie:
	@echo ""
	@echo "DEB packaging ----------------------------------------------------------"
	-rm -Rf $(DEB_FILE_JESSIE)
	fpm   \
	--verbose   \
	--input-type dir   \
	--output-type deb   \
	--name $(DEB_NAME_JESSIE)   \
	--version $(DEB_VERSION_JESSIE)   \
	--package $(DEB_FILE_JESSIE)   \
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

# deb-jessie and deb-stretch are identical.
deb-stretch:
	@echo ""
	@echo "DEB packaging ----------------------------------------------------------"
	-rm -Rf $(DEB_FILE_STRETCH)
	fpm   \
	--verbose   \
	--input-type dir   \
	--output-type deb   \
	--name $(DEB_NAME_STRETCH)   \
	--version $(DEB_VERSION_STRETCH)   \
	--package $(DEB_FILE_STRETCH)   \
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
