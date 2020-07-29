# Release Procedure

Version:

Gluon Version: 


## Pre-Build

- [ ] Create Version Branch
- [ ] Update README.md

Summarize changes on site-ffhl:

- ... 

- [ ] Create Versions Tag
- [ ] Create Merge Request

## Build Firmware

- [ ] Build Firmware / Run CI. (Firmware for rollout should be build on trusted hardware)
- [ ] Visually check that `output/images/*` and the contents of `output/images/sysupgrade/{stable,beta}.manifest` looks fine.
- [ ] make sure, all desired targets were built
- [ ] copy output images to srv01 

## Beta Release

- [ ] manually download and flash a few images to a few devices to check that the overall build process went fine. 

### Sign Firmware

- [ ] Get minimum amount of signatures 
- [ ] Update the beta.manifest on the server with the new, added signatures below the "---" in the local copy of the beta.manifest.
- [ ] update `beta` symlink on srv01

### Monitor Beta Nodes

Then check for about 2 weeks that nodes with the beta branch selected in their autoupdater updated and run fine. Make sure to have at least one device of the more popular ones on a beta branch.

- [ ] Nodes are alive and stable with new version number (check node's status page)
- [ ] Check that all wifi interfaces are up and running (run ``iwinfo`` via ssh)
- [ ] Check that meshing works (run ``batctl o`` via ssh)
- [ ] Check that the process list looks fine (run ``ps`` via ssh - no missing processes? no new, suspicious processes?)
- [ ] Check that `/etc/config/autoupdater` looks fine and has the correct public keys
- [ ] Check that `/etc/dropbear/authorized_keys` was left unmodified

If not, abort and repeat process with increased build number

## Stable Release

- [ ] Update DATE in local stable.manifest
- [ ] Get minimum amount of signatures 
- [ ] Update the DATE in the stable.manifest on the server with the new start time.
- [ ] Update the stable.manifest on the server with the new, added signatures below the "---" in the local copy of the stable.manifest.
- [ ] update `stable` symlink on srv01:

### Pre-Stable-Rollout

- [ ] Verify that images are downloadable via https://luebeck.freifunk.net/firmware/0.xx.y-z/sysupgrade/
- [ ] Verify that stable.manifest on the server contains a sufficient amount of valid signatures
- [ ] Verify that the start DATE of the stable.manifest on the server is correct
- [ ] Then prior the stable update start date, inform passengers: Inform about scheduled landing time of the new release and the firmware changes it contains on the talk@luebeck.freifunk.net mailing list.

### Peri-Stable-Rollout

* Daily:
  * Check that the predicted number of nodes updates to the new firmware version
  * For the nodes which updated successfully, check their status page:
    * enough RAM
    * load ok (usually < 1)
    * neighbor link quality ok
  * Monitor mailing lists for passenger feedback

In case of any issues occurring, abort.

### Post-Stable-Rollout

- [ ] Check if any nodes might have failed updating (any nodes that might have gone offline, especially during the update time at about 04:00 o'clock.
  * If available, inform individual node owners via the contact information they set in the config-mode about their failed update. If possible, determine cause for failure.
- [ ] Update firmware version and models on the website: https://luebeck.freifunk.net/firmware.html
  * set "FIRMWARE_VERSION" in _plugins/firmwares.rb
  * run "jekyll build"
  * check for warnings about unknown/new devices: add them to firmwares.rb
  * rerun "jekyll build" and update firmware.rb until no more warnings occur
  * git-commit and -push changes
- [ ] Update https://luebeck.freifunk.net/: Add a new blog entry to inform about the new firmware release
- [ ] Inform via Twitter about the new firmware release
- [ ] Increment DEFAULT_GLUON_RELEASE in https://gitlab.com/freifunk-luebeck/site-ffhl/blob/master/site.mk


See [wiki](https://wiki.luebeck.freifunk.net/docs/firmware/release-procedure/) for more details.
