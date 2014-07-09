# http://stackoverflow.com/questions/18136918/how-to-get-current-directory-of-your-makefile
this_dir := $(shell dirname $(abspath $(lastword $(MAKEFILE_LIST))))

GLUON_SITE_PACKAGES := \
	gluon-alfred \
	gluon-autoupdater \
	gluon-config-mode \
	gluon-ebtables-filter-multicast \
	gluon-ebtables-filter-ra-dhcp \
	gluon-luci-admin \
	gluon-luci-autoupdater \
	gluon-next-node \
	gluon-mesh-batman-adv \
	gluon-mesh-vpn-fastd \
	gluon-radvd \
	gluon-status-page \
	iwinfo \
	iptables \
	haveged

DEFAULT_GLUON_CHECKOUT := v2014.2
# Allow overriding the checkout from the command line
GLUON_CHECKOUT ?= $(DEFAULT_GLUON_CHECKOUT)

DEFAULT_GLUON_RELEASE := $(shell git -C $(this_dir) describe --tags --always --dirty --match "v*" | sed 's/^v//')
# Allow overriding the release number from the command line
GLUON_RELEASE ?= $(DEFAULT_GLUON_RELEASE)
