GLUON_SITE_PACKAGES := \
        gluon-mesh-batman-adv-15 \
        gluon-alfred \
        gluon-autoupdater \
        gluon-authorized-keys \
        gluon-config-mode-autoupdater \
        gluon-config-mode-core \
        gluon-config-mode-hostname \
        gluon-config-mode-mesh-vpn \
        gluon-config-mode-geo-location \
        gluon-config-mode-contact-info \
        gluon-ebtables-filter-multicast \
        gluon-ebtables-filter-ra-dhcp \
        gluon-luci-admin \
        gluon-luci-autoupdater \
        gluon-luci-mesh-vpn-fastd \
        gluon-luci-portconfig \
        gluon-luci-private-wifi \
        gluon-luci-wifi-config \
        gluon-next-node \
        gluon-neighbour-info \
        gluon-mesh-vpn-fastd \
        gluon-radvd \
		gluon-respondd \
        gluon-status-page \
        gluon-setup-mode \
        iwinfo \
        iptables \
        haveged


DEFAULT_GLUON_CHECKOUT := master
# Allow overriding the checkout from the command line
GLUON_CHECKOUT ?= $(DEFAULT_GLUON_CHECKOUT)

DEFAULT_GLUON_RELEASE := 0.9+exp$(shell date '+%Y%m%d')

# Allow overriding the release number from the command line
GLUON_RELEASE ?= $(DEFAULT_GLUON_RELEASE)

GLUON_PRIORITY ?= 0

GLUON_LANGS ?= de en
