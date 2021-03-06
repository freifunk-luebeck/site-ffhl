GLUON_FEATURES := \
	alfred \
	autoupdater \
	config-mode-geo-location-osm \
	ebtables-filter-multicast \
	ebtables-filter-ra-dhcp \
	ebtables-source-filter \
	mesh-batman-adv-15 \
	mesh-vpn-fastd \
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


DEFAULT_GLUON_RELEASE := 0.17~exp$(shell date '+%Y%m%d')

# Allow overriding the release number from the command line
GLUON_RELEASE ?= $(DEFAULT_GLUON_RELEASE)

GLUON_PRIORITY ?= 0

GLUON_REGION ?= eu
GLUON_LANGS ?= en de

GLUON_MULTIDOMAIN=1

GLUON_DEPRECATED?=full

GLUON_BRANCH?=stable
