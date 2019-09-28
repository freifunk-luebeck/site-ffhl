##      GLUON_FEATURES
#               Specify Gluon features/packages to enable;
#               Gluon will automatically enable a set of packages
#               depending on the combination of features listed

GLUON_FEATURES := \
        autoupdater \
        ebtables-filter-multicast \
        ebtables-filter-ra-dhcp \
        mesh-batman-adv-15 \
        mesh-vpn-fastd \
        respondd \
        status-page \
        web-advanced \
        web-wizard

##      GLUON_SITE_PACKAGES
#               Specify additional Gluon/LEDE packages to include here;
#               A minus sign may be prepended to remove a packages from the
#               selection that would be enabled by default or due to the
#               chosen feature flags

GLUON_SITE_PACKAGES := \
        gluon-alfred \
        gluon-authorized-keys \
        gluon-config-mode-geo-location-osm \
        gluon-neighbour-info \
        gluon-radvd \
        gluon-web-model \
        gluon-web-node-role \
        gluon-web-private-wifi \
        haveged \
        iwinfo 

DEFAULT_GLUON_CHECKOUT := master
# Allow overriding the checkout from the command line
GLUON_CHECKOUT ?= $(DEFAULT_GLUON_CHECKOUT)

DEFAULT_GLUON_RELEASE := 1.0+exp$(shell date '+%Y%m%d')

DEFAULT_GLUON_BRANCH := experimental

GLUON_ATH10K_MESH ?= 11s

GLUON_WLAN_MESH ?= 11s

# Allow overriding the release number from the command line
GLUON_RELEASE ?= $(DEFAULT_GLUON_RELEASE)

GLUON_IMAGEDIR ?= $(GLUON_OUTPUTDIR)/images

GLUON_PRIORITY ?= 0

GLUON_REGION ?= eu

GLUON_LANGS ?= de en

GLUON_DEPRECATED ?= full
