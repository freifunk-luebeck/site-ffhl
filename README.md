Freifunk-Magdeburg-specific Gluon configuration
===============================================

How to build the Freifunk Magdeburg Firmware
--------------------------------------------

This is building FFMD firmware in a nutshell. For more on options or
building specific branches please refer to the build script or [the official
Gluon repository](https://github.com/freifunk-gluon/gluon) at GitHub.

The building requires packages for subversion, ncurses headers 
(libncurses-dev) and zlib headers (libz-dev).

With Debian Linux, install by:

    sudo aptitude install subversion libz-dev libncurses5-dev

then download and build as follows:

    git clone git://github.com/freifunk-gluon/gluon.git         # Get the official Gluon repository
    cd gluon
    git clone git://github.com/FreifunkMD/site-ffmd.git site    # Get the Freifunk Magdeburg site repository
    make update                                                 # Fetch all repositories
    ./site/build.sh

In order to get a more verbose output, e.g. in case of build errors,
you can call

    ./site/build.sh -v

Updating your node via ssh
--------------------------------------------
If possible, use the [Config Mode](http://gluon.readthedocs.org/en/latest/features/configmode.html) to update your node.

In case you do not have physical access to your router, an update can be performed using SSH. Connect to your device via IPv6 and issue the following commands, using the firmware file that matches your device:

    cd /tmp 
    wget http://firmware.md.freifunk.net/stable/LATEST/sysupgrade/gluon-ffmd-0.28-tp-link-tl-wr841n-nd-v9-sysupgrade.bin 
    sync; sysctl -w vm.drop_caches=3
    sysupgrade gluon-ffmd-0.28-tp-link-tl-wr841n-nd-v9-sysupgrade.bin

Be sure you know what you are doing!

Verify a successful upgrade by
* checking that the node is back up and running (i.e. visible in the nodes list)
* checking that the host name and your login data are still available. A failed sysupgrade may leave the node in a state of running Freifunk with a weird configuration.

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
