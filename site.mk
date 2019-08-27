GLUON_FEATURES := \
	alfred \
	autoupdater \
	config-mode-geo-location-osm \
	ebtables-filter-multicast \
	ebtables-filter-ra-dhcp \
	ebtables-source-filter \
	mesh-batman-adv-14 \
	mesh-vpn-fastd \
	radvd \
	respondd \
	status-page \
	web-advanced \
	web-mesh-vpn-fastd \
	web-private-wifi \
	web-wizard

GLUON_SITE_PACKAGES := \
	haveged \
	iwinfo \
	respondd-module-airtime


DEFAULT_GLUON_RELEASE := 0.13~exp$(shell date '+%Y%m%d')

# Allow overriding the release number from the command line
GLUON_RELEASE ?= $(DEFAULT_GLUON_RELEASE)

GLUON_PRIORITY ?= 0

GLUON_REGION ?= eu
GLUON_LANGS ?= en de

GLUON_WLAN_MESH=ibss
