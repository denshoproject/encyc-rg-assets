PROJECT=encyc
APP=encycrgassets
USER=encyc
SHELL = /bin/bash

APP_VERSION := $(shell cat VERSION)
GIT_SOURCE_URL=https://github.com/densho/encyc-rg-assets

INSTALL_BASE=/opt
INSTALLDIR=$(INSTALL_BASE)/encyc-rg-assets

MEDIA_BASE=/var/www/encycrg
MEDIA_ROOT=$(MEDIA_BASE)/media
ASSETS_ROOT=$(MEDIA_BASE)/assets
STATIC_ROOT=$(MEDIA_BASE)/static

# Release name e.g. jessie
DEBIAN_CODENAME := $(shell lsb_release -sc)
# Release numbers e.g. 8.10
DEBIAN_RELEASE := $(shell lsb_release -sr)
# Sortable major version tag e.g. deb8
DEBIAN_RELEASE_TAG = deb$(shell lsb_release -sr | cut -c1)

# Adding '-rcN' to VERSION will name the package "ddrlocal-release"
# instead of "ddrlocal-BRANCH"
DEB_BRANCH := $(shell python3 bin/package-branch.py)
DEB_ARCH=amd64
DEB_NAME_BULLSEYE=$(APP)-$(DEB_BRANCH)
DEB_NAME_BOOKWORM=$(APP)-$(DEB_BRANCH)
DEB_NAME_TRIXIE=$(APP)-$(DEB_BRANCH)
# Application version, separator (~), Debian release tag e.g. deb8
# Release tag used because sortable and follows Debian project usage.
DEB_VERSION_BULLSEYE=$(APP_VERSION)~deb11
DEB_VERSION_BOOKWORM=$(APP_VERSION)~deb12
DEB_VERSION_TRIXIE=$(APP_VERSION)~deb13
DEB_FILE_BULLSEYE=$(DEB_NAME_BULLSEYE)_$(DEB_VERSION_BULLSEYE)_$(DEB_ARCH).deb
DEB_FILE_BOOKWORM=$(DEB_NAME_BOOKWORM)_$(DEB_VERSION_BOOKWORM)_$(DEB_ARCH).deb
DEB_FILE_TRIXIE=$(DEB_NAME_TRIXIE)_$(DEB_VERSION_TRIXIE)_$(DEB_ARCH).deb
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


install:
	@echo ""
	@echo "install -----------------------------------------------------------------"
	-mkdir $(MEDIA_BASE)
	-mkdir $(MEDIA_ROOT)
	chown -R ddr.root $(MEDIA_ROOT)
	chmod -R 755 $(MEDIA_ROOT)
	-mkdir $(ASSETS_ROOT)
	-mkdir $(STATIC_ROOT)
	-cp -R $(INSTALLDIR)/assets/* $(ASSETS_ROOT)/
	-cp -R $(INSTALLDIR)/static/* $(STATIC_ROOT)/

clean:
	-rm -Rf $(ASSETS_ROOT)/
	-rm -Rf $(STATIC_ROOT)/


# http://fpm.readthedocs.io/en/latest/
install-fpm:
	@echo "install-fpm ------------------------------------------------------------"
	apt-get install --assume-yes ruby ruby-dev rubygems build-essential
	gem install --no-document fpm

# https://stackoverflow.com/questions/32094205/set-a-custom-install-directory-when-making-a-deb-package-with-fpm
# https://brejoc.com/tag/fpm/
deb: deb-bullseye

deb-bullseye:
	@echo ""
	@echo "FPM packaging (bullseye) -----------------------------------------------"
	-rm -Rf $(DEB_FILE_BULLSEYE)
# Make package
	fpm   \
	--verbose   \
	--input-type dir   \
	--output-type deb   \
	--name $(DEB_NAME_BULLSEYE)   \
	--version $(DEB_VERSION_BULLSEYE)   \
	--package $(DEB_FILE_BULLSEYE)   \
	--url "$(GIT_SOURCE_URL)"   \
	--vendor "$(DEB_VENDOR)"   \
	--maintainer "$(DEB_MAINTAINER)"   \
	--description "$(DEB_DESCRIPTION)"   \
	--chdir $(INSTALLDIR)   \
	media=var/www/encycfront   \
	static=var/www/encycrg   \
	.git=$(DEB_BASE)   \
	.gitignore=$(DEB_BASE)   \
	media=$(DEB_BASE)   \
	INSTALL=$(DEB_BASE)   \
	Makefile=$(DEB_BASE)   \
	README=$(DEB_BASE)   \
	static=$(DEB_BASE)   \
	VERSION=$(DEB_BASE)

deb-bookworm:
	@echo ""
	@echo "FPM packaging (bookworm) -----------------------------------------------"
	-rm -Rf $(DEB_FILE_BOOKWORM)
# Make package
	fpm   \
	--verbose   \
	--input-type dir   \
	--output-type deb   \
	--name $(DEB_NAME_BOOKWORM)   \
	--version $(DEB_VERSION_BOOKWORM)   \
	--package $(DEB_FILE_BOOKWORM)   \
	--url "$(GIT_SOURCE_URL)"   \
	--vendor "$(DEB_VENDOR)"   \
	--maintainer "$(DEB_MAINTAINER)"   \
	--description "$(DEB_DESCRIPTION)"   \
	--chdir $(INSTALLDIR)   \
	media=var/www/encycfront   \
	static=var/www/encycrg   \
	.git=$(DEB_BASE)   \
	.gitignore=$(DEB_BASE)   \
	media=$(DEB_BASE)   \
	INSTALL=$(DEB_BASE)   \
	Makefile=$(DEB_BASE)   \
	README=$(DEB_BASE)   \
	static=$(DEB_BASE)   \
	VERSION=$(DEB_BASE)

deb-trixie:
	@echo ""
	@echo "FPM packaging (trixie) -----------------------------------------------"
	-rm -Rf $(DEB_FILE_TRIXIE)
# Make package
	fpm   \
	--verbose   \
	--input-type dir   \
	--output-type deb   \
	--name $(DEB_NAME_TRIXIE)   \
	--version $(DEB_VERSION_TRIXIE)   \
	--package $(DEB_FILE_TRIXIE)   \
	--url "$(GIT_SOURCE_URL)"   \
	--vendor "$(DEB_VENDOR)"   \
	--maintainer "$(DEB_MAINTAINER)"   \
	--description "$(DEB_DESCRIPTION)"   \
	--chdir $(INSTALLDIR)   \
	media=var/www/encycfront   \
	static=var/www/encycrg   \
	.git=$(DEB_BASE)   \
	.gitignore=$(DEB_BASE)   \
	media=$(DEB_BASE)   \
	INSTALL=$(DEB_BASE)   \
	Makefile=$(DEB_BASE)   \
	README=$(DEB_BASE)   \
	static=$(DEB_BASE)   \
	VERSION=$(DEB_BASE)
