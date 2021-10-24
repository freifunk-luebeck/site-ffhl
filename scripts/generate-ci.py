#!/usr/bin/python3

import yaml
import subprocess
import os


ARTIFACTS_EXPIRE="3 day"

MAKE_FLAGS=["--silent", "-C", "gluon", "GLUON_SITEDIR=.."]

def get_available_targets():
	res = subprocess.run(["make", *MAKE_FLAGS, "list-targets"], stdout=subprocess.PIPE)
	return res.stdout.decode('utf-8').strip().split("\n")

BEFORE_SCRIPT = [
	"apt-get update > /dev/null",
	"apt-get install -y curl git libncurses-dev build-essential make gawk unzip wget python2.7 file tar bzip2 tree ccache ecdsautils > /dev/null",
	"mkdir -p ccache",
	'PATH="/usr/lib/ccache:$PATH"',
]

VARIABLES = {
	"CCACHE_DIR": "$CI_PROJECT_DIR/ccache",
	"CCACHE_MAXSIZE": "20G"
}

ci = {
	"image": "debian:buster",
	"default": {
		"interruptible": True
	},
	"before_script": BEFORE_SCRIPT,
	"variables": {
		"GIT_SUBMODULE_STRATEGY": "recursive",
		"FORCE_UNSAFE_CONFIGURE": "1",
		**VARIABLES,
	},
	"stages": [
		"pre-build-tests",
		"build",
		"test",
		"prepare-deploy",
		"test-deploy",
		"deploy",
	]
}


# some tests before we do anything

ci['check-ci-tests'] = {
	"image": "alpine:latest",
	"stage": "pre-build-tests",
	"allow_failure": False,
	"before_script": [
		"apk update",
		"apk add shellcheck bash"
	],
	"script": [
		"shellcheck scripts/ci/test_manifest_length.sh"
	]
}



ci['build-all'] = {
	"stage": "build",
	"tags": ["fast"],
	"cache": {
		"paths": ['ccache'],
		"key": "${TARGET}",
	},
	"parallel": {
		"matrix": [
			{"TARGET": get_available_targets()}
		]
	},
	"variables": {
		"GLUON_SITEDIR": "..",
		"GLUON_DEPRECATED": 1,
		"GLUON_AUTOUPDATER_ENABLED": 1,
		"GLUON_AUTOUPDATER_BRANCH": "stable",
		"GLUON_BRANCH": "$GLUON_AUTOUPDATER_BRANCH",
		**VARIABLES,
	},
	"script": [
		"file $(which gcc)",
		"tree -L 3",
		"env | grep CI",
		"make -C gluon update",
		"make -C gluon -j $((($(nproc)+1) / 2)) GLUON_TARGET=$TARGET ",
		"ccache -s"
	],
	"artifacts": {
		"when": "always",
		"expire_in": ARTIFACTS_EXPIRE,
		"paths": ["gluon/output"]
	}
}


ci['test:images'] = {
	"stage": "test",
	"needs": ["build-all"],
	"allow_failure": True,
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
		"expire_in": ARTIFACTS_EXPIRE,
		"paths": ["gluon/output"]
	}
}

ci['test:image-count'] = {
	"stage": "test",
	"needs": ["build-all"],
	"allow_failure": True,
	"before_script": [
		"apt update",
		"apt install -qq -y tree"
	],
	"script": [
		# check the number of images
		"N=$(ls gluon/output/images/sysupgrade/ | wc -l)",
		"echo $N",
		"[ $N -ge 260 ]"
	],
	"artifacts": {
		"when": "always",
		"expire_in": ARTIFACTS_EXPIRE,
		"paths": ["gluon/output"]
	}
}



ci['manifest'] = {
	"stage": "prepare-deploy",
	"needs": ["build-all"],
	"tags": ["fast"],
	"cache": {
		"paths": ['ccache'],
		"key": "manifest",
	},
	"variables": {
		"FORCE_UNSAFE_CONFIGURE": "1",
	},
	"script": [
		"make -C gluon GLUON_SITEDIR=.. update",
		"make -C gluon GLUON_SITEDIR=.. GLUON_PRIORITY=7 GLUON_AUTOUPDATER_BRANCH=stable GLUON_BRANCH=stable manifest",
		"make -C gluon GLUON_SITEDIR=.. GLUON_PRIORITY=0 GLUON_AUTOUPDATER_BRANCH=beta GLUON_BRANCH=beta manifest",
		"make -C gluon GLUON_SITEDIR=.. GLUON_PRIORITY=0 GLUON_AUTOUPDATER_BRANCH=experimental GLUON_BRANCH=experimental manifest",
		"echo $SIGNING_KEY > ecdsa.key",
		"./gluon/contrib/sign.sh ecdsa.key gluon/output/images/sysupgrade/experimental.manifest",
	],
	"artifacts": {
		"when": "always",
		"expire_in": ARTIFACTS_EXPIRE,
		"paths": ["gluon/output"]
	}
}



ci['test:manifest-length'] = {
	"stage": "test-deploy",
	"needs": ["manifest"],
	"before_script": [],
	"script": [
		# check the number of images
		"bash scripts/ci/test_manifest_length.sh"
	],
	"artifacts": {
		"when": "always",
		"paths": ["gluon/output"]
	}
}



ci['upload'] = {
	"stage": "deploy",
	# "needs": ["test:images", "test:image-count", "manifest"],
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
		"TAG=${CI_COMMIT_BRANCH}_$(date +%F_%H-%M-%S)",
		'mkdir -p "public/$TAG"',
		"cd gluon",
		"mv output $TAG",
		'ln -s ./$TAG ./latest',
		'rsync -rvhl ./$TAG ${DEPLOY_USER}@${DEPLOY_HOST}:data/',
		'rsync -rvhl ./latest ${DEPLOY_USER}@${DEPLOY_HOST}:data/',
	]
}

ci['pages'] = {
	"stage": "deploy",
	# "needs": ["test:images", "test:image-count", "manifest"],
	"script": [
		"TAG=${CI_COMMIT_REF_SLUG}_$(date +%F_%H-%M-%S)",
		'mkdir -p public',
		"mv gluon/output/* public",
		'find public/ -type d -exec sh -c \'tree -I "index.html" -H "." -T "$TAG" -s -h --si -L 2 "{}" > "{}/index.html" \' \;',
	],
	"artifacts": {
		"when": "always",
		"expire_in": ARTIFACTS_EXPIRE,
		"paths": ["public"]
	},
	# only upload if this is the default branch
	"rules": [
		{"if": "$CI_COMMIT_REF_NAME == $CI_DEFAULT_BRANCH"}
	]

}



print(yaml.dump(ci, sort_keys=False,))
# print(get_available_targets())
