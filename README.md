Freifunk-Magdeburg-specific Gluon configuration
===============================================

How to build the Freifunk Magdeburg Firmware
--------------------------------------------

This is building FFMD firmware in a nutshell. For more on options or
building specific branches please refer to the build script or [the official
Gluon repository](https://github.com/freifunk-gluon/gluon) at GitHub.

    git clone git://github.com/freifunk-gluon/gluon.git         # Get the official Gluon repository
    cd gluon
    git clone git://github.com/FreifunkMD/site-ffmd.git site    # Get the Freifunk Magdeburg site repository
    make update                                                 # Fetch all repositories
    ./site/build.sh

Gluon versions used for specific Magdeburg Freifunk Firmware builds
-------------------------------------------------------------------

* 0.29: *gluon 2014.3*
  * see http://gluon.readthedocs.org/en/latest/releases/v2014.3.html
* 0.28: *gluon 2014.2*
  * **note** first version with specific gluon version, previous were
    simply built from arbitrary master states
  * new build script to enable the above
  * added package gluon-firewall
  * replaced FFHL auto-update keys by FFMD keys
  * changed auto-update URLs for later use
* 0.27
  * added link to the registerseite
* 0.26
  * first ffmd gluon version
