Freifunk Magdeburg specific Gluon configuration
===============================================

How to build the Freifunk Magdeburg Firmware
--------------------------------------------

This is building FFMD firmware in a nutshell. For more options or
building specific branches please see our build script or [the official
Gluon repository](https://github.com/freifunk-gluon/gluon) at GitHub.

    git clone git://github.com/freifunk-gluon/gluon.git         # Get the official Gluon repository
    cd gluon
    git clone git://github.com/FreifunkMD/site-ffmd.git site    # Get the Freifunk Magdeburg site repository
    ./site/build.sh

Gluon versions used for specific Magdeburg Freifunk Firmware builds
-------------------------------------------------------------------

* 0.28: v2014.2
  * note: first version with specific gluon version, previous were just
    build from arbitrary master states
* 0.27
  * add Link to the registerseite
* 0.26
  * first ffmd gluon version
