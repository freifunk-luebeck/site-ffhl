GLUON_FEATURES := \
	alfred \
	autoupdater \
	config-mode-geo-location-osm \
	ebtables-filter-multicast \
	ebtables-filter-ra-dhcp \
	ebtables-source-filter \
	mesh-batman-adv-15 \
	mesh-vpn-fastd \
	mesh-vpn-fastd-l2tp \
	scheduled-domain-switch \
	radvd \
	respondd \
	status-page \
	web-advanced \
	web-mesh-vpn-fastd \
	web-private-wifi \
	web-wizard

GLUON_SITE_PACKAGES := \
	iwinfo \
	respondd-module-airtime


DEFAULT_GLUON_RELEASE := 0.14.2~exp$(shell date '+%Y%m%d')

# gitlab-ci: use commit tag, if avalable as version number
GLUON_RELEASE ?= $(CI_COMMIT_TAG)
ifeq ($(GLUON_RELEASE),)
	GLUON_RELEASE := $(DEFAULT_GLUON_RELEASE)
endif


GLUON_AUTOUPDATER_ENABLED = 1
GLUON_AUTOUPDATER_BRANCH ?= stable
GLUON_PRIORITY ?= 0

GLUON_REGION ?= eu
GLUON_LANGS ?= en de

GLUON_MULTIDOMAIN=1

GLUON_DEPRECATED?=full

GLUON_BRANCH?=stable
