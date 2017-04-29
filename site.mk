GLUON_SITE_PACKAGES := \
        gluon-alfred \
        gluon-autoupdater \
        gluon-authorized-keys \
        gluon-config-mode-autoupdater \
	gluon-config-mode-contact-info \
        gluon-config-mode-core \
        gluon-config-mode-hostname \
        gluon-config-mode-mesh-vpn \
        gluon-config-mode-geo-location \
	gluon-core \
        gluon-ebtables-filter-multicast \
        gluon-ebtables-filter-ra-dhcp \
        gluon-web-admin \
        gluon-web-autoupdater \
        gluon-web-mesh-vpn-fastd \
	gluon-web-network \
	gluon-web-node-role \
        gluon-web-private-wifi \
        gluon-web-wifi-config \
	gluon-web-theme \
        gluon-neighbour-info \
        gluon-mesh-batman-adv \
	gluon-mesh-vpn-core \
        gluon-mesh-vpn-fastd \
        gluon-radvd \
        gluon-respondd \
        gluon-setup-mode \
        gluon-status-page \
        iwinfo \
        iptables \
        haveged


DEFAULT_GLUON_CHECKOUT := master
# Allow overriding the checkout from the command line
GLUON_CHECKOUT ?= $(DEFAULT_GLUON_CHECKOUT)

DEFAULT_GLUON_RELEASE := 1.0+exp$(shell date '+%Y%m%d')

DEFAULT_GLUON_BRANCH := experimental

GLUON_ATH10K_MESH ?= ibss

# Allow overriding the release number from the command line
GLUON_RELEASE ?= $(DEFAULT_GLUON_RELEASE)

GLUON_IMAGEDIR ?= $(GLUON_OUTPUTDIR)/images

GLUON_PRIORITY ?= 0

GLUON_REGION ?= eu

GLUON_LANGS ?= de en

