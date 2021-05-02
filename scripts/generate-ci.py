#!/usr/bin/python3

import yaml
import subprocess
import os

MAKE_FLAGS=["--silent", "-C", "gluon", "GLUON_SITEDIR=.."]

def get_available_targets():
	res = subprocess.run(["make", *MAKE_FLAGS, "list-targets"], stdout=subprocess.PIPE)
	return res.stdout.decode('utf-8').strip().split("\n")

BEFORE_SCRIPT = [
	"apt-get update > /dev/null",
	"apt-get install -y curl git libncurses-dev build-essential make gawk unzip wget python2.7 file tar bzip2 tree > /dev/null",
]

ci = {
	"image": "debian:stable",
	"default": {
		"interruptible": True
	},
	"variables": {
		"GIT_SUBMODULE_STRATEGY": "recursive",
	},
	"stages": [
		"build",
		"test",
		"deploy",
		"upload",
	],
	"build-all": {
		"stage": "build",
		# "tags": ["tars"],
		# "variables": {
		# 	""
		# },
		"before_script": BEFORE_SCRIPT,
		"parallel": {
			"matrix": [
				{"TARGET": get_available_targets()}
			]
		},
		"script": [
			"tree -L 3",
			"GLUON_TARGET=$TARGET ./scripts/build-images.sh",
		],
		"cache": {
			"paths": [
				# "gluon/openwrt",
				# "gluon/tmp",
				# "gluon/packages"
			],
		},
		"artifacts": {
			"when": "always",
			"paths": ["gluon/output"]
		}
	}
}


ci['test:images'] = {
	"stage": "test",
	"needs": ["build-all"],
	"before_script": [
		"apt update",
		"apt install -qq -y tree"
	],
	"script": [
		# these are the most used devices in luebeck
		"ls gluon/output/images/sysupgrade/ | grep wdr3600",
		"ls gluon/output/images/sysupgrade/ | grep wr841",
		"ls gluon/output/images/sysupgrade/ | grep ubiquiti-unifi",
		"ls gluon/output/images/sysupgrade/ | grep nanostation-m2",
		"ls gluon/output/images/sysupgrade/ | grep wr1043n",
		"ls gluon/output/images/sysupgrade/ | grep wdr4300",
	],
	"artifacts": {
		"when": "always",
		"paths": ["gluon/output"]
	}
}

ci['test:image-count'] = {
	"stage": "test",
	"needs": ["build-all"],
	"before_script": [
		"apt update",
		"apt install -qq -y tree"
	],
	"script": [
		# check the number of images
		"N=$(ls gluon/output/images/sysupgrade/ | wc -l)",
		"[ $N -ge 260 ]"
	],
	"artifacts": {
		"when": "always",
		"paths": ["gluon/output"]
	}
}



ci['manifest'] = {
	"stage": "deploy",
	"needs": ["build-all"],
	"before_script": [
		"apt update",
		"apt install -y ecdsautils curl git libncurses-dev build-essential make gawk unzip wget python2.7 file tar bzip2 tree"
	],
	"script": [
		"make -C gluon GLUON_SITEDIR=.. update",
		"make -C gluon GLUON_SITEDIR=.. manifest GLUON_BRANCH=experimental",
		"make -C gluon GLUON_SITEDIR=.. manifest GLUON_BRANCH=beta",
		"make -C gluon GLUON_SITEDIR=.. manifest GLUON_BRANCH=stable",
		"$SIGNING_KEY > ecdsa.key",
		"./gluon/contrib/sign.sh ecdsa.key gluon/output/images/sysupgrade/experimental.manifest",
	],
	"artifacts": {
		"when": "always",
		"paths": ["gluon/output"]
	}
}


ci['deploy'] = {
	"stage": "upload",
	"before_script": [
		"apt-get -qq update",
		"apt-get -qq install -y git make gawk wget python2.7 file tar bzip2 rsync tree",
		"mkdir -p ~/.ssh",
		'echo -e "StrictHostKeyChecking no" > ~/.ssh/config',
		"eval $(ssh-agent -s)",
		'echo "$DEPLOY_KEY" | ssh-add -',
	],
	"script": [
		"tree -L 3 gluon/output",
		"DATE=$(date +%F-%H-%M-%S)",
		'mkdir -p "public/$DATE"',
		"cd gluon",
		"mv output $DATE",
		'ln -s ./$DATE ./latest',
		'rsync -rvhl ./$DATE ${DEPLOY_USER}@${DEPLOY_HOST}:data/',
		'rsync -rvhl ./latest ${DEPLOY_USER}@${DEPLOY_HOST}:data/',
	]
}



print(yaml.dump(ci, sort_keys=False))
# print(get_available_targets())
