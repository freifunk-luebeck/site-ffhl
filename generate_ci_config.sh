#!/bin/bash
set -e

TARGETS=$(make list-targets)
UPLOADTAG=$(date +%F-%H-%M-%S)


echo "targets:" >&2
make list-targets >&2


# static section
cat << EOF
image: debian:stable
before_script:
  - apt-get -qq update
  - apt-get -qq install -y curl git libncurses-dev build-essential make gawk unzip wget python2.7 file tar bzip2 pandoc rsync


stages:
  - init
  - build
  - deploy


init:
  stage: init
  before_script:
    - apt-get -qq update
    - apt-get -qq install -y curl git libncurses-dev build-essential make gawk unzip wget python2.7 file tar bzip2 pandoc rsync

  script:
    - env | grep -i GLUON
    - git clone -q https://github.com/freifunk-gluon/gluon.git
    - cd gluon
    - git checkout $FFHL_GLUON_VERSION
    - git clone  ../ site
    # - make update
  artifacts:
    when: always
    paths:
      - gluon


# UPLOAD RESULTS OF ${target}
create_manifest:
  stage: deploy
  needs:
$(make list-targets | sed 's/^/    - build_/gm' )

  before_script:
    - apt-get -qq update
    - apt-get -qq install -y git make gawk wget python2.7 file tar bzip2 rsync tree

  script:
    - mkdir -p ~/.ssh
    - 'echo -e "StrictHostKeyChecking no" > ~/.ssh/config'
    - eval \$(ssh-agent -s)
    - echo "\$DEPLOY_KEY" | ssh-add -
    - tree -L 3
    - cd gluon
    - make manifest GLUON_BRANCH=experimental GLUON_PRIORITY=0
    - make manifest GLUON_BRANCH=beta GLUON_PRIORITY=0
    - make manifest GLUON_BRANCH=stable GLUON_PRIORITY=7
    # - mkdir -p ../public/${CI_COMMIT_REF_SLUG}
    # - cp -rv output/images/ ../public/${CI_COMMIT_REF_SLUG}
    - find $UPLOADTAG -maxdepth 2
    - rsync -rvhl ./output/images/sysupgrade/experimental.manifest \${DEPLOY_USER}@\${DEPLOY_HOST}:data/$UPLOADTAG/images/sysupgrade/beta.manifest
    - rsync -rvhl ./output/images/sysupgrade/beta.manifest \${DEPLOY_USER}@\${DEPLOY_HOST}:data/$UPLOADTAG/images/sysupgrade/beta.manifest
    - rsync -rvhl ./output/images/sysupgrade/stable.manifest \${DEPLOY_USER}@\${DEPLOY_HOST}:data/$UPLOADTAG/images/sysupgrade/beta.manifest
  # cache:
  #   # key: ${CI_COMMIT_REF_SLUG}
  #   # ${CI_JOB_NAME}
  #   paths:
  #     - gluon
  # only:
  # - master

EOF




# generate variables section:
echo "variables:"
for variable in $(env | grep GLUON_); do
  echo "  $variable" | sed 's/\=/: /'
done

echo -e "\n\n"


# generate jobs for all targets

for target in $TARGETS; do
  cat << EOF

# BUILD FOR TARGET ${target}
build_${target}:
  stage: build
  needs: ["init"]
  variables:
    GLUON_TARGET: ${target}
  script:
    - env | grep -i GLUON
    - cd gluon
  #  - (make -j 1 V=s 2>&1) > log_gluon || { tail -n 100 log_gluon; exit 1; }
  #  - (make -j \$(nproc) V=s 2>&1) > log_gluon || { tail -n 100 log_gluon; exit 1; }
    - echo "build build build..."
    - sleep 30
    - mkdir -p output/images/sysupgrade/
    - mkdir -p output/images/factory/
    - mkdir -p output/images/other/
    - touch output/images/sysupgrade/foorouter.bin
    - touch output/images/factory/foorouter.bin
    - touch output/images/other/foorouter.bin
  cache:
    key: ${CI_JOB_NAME}_\${CI_COMMIT_BRANCH}
    paths:
      - gluon
  only:
    - master
    - gitlab-ci
  artifacts:
    paths:
    - gluon

# UPLOAD RESULTS OF ${target}
upload_${target}:
  stage: deploy
  needs: ["build_${target}"]
  before_script:
    - apt-get -qq update
    - apt-get -qq install -y git make gawk wget python2.7 file tar bzip2 rsync

  script:
    - mkdir -p ~/.ssh
    - 'echo -e "StrictHostKeyChecking no" > ~/.ssh/config'
    - eval \$(ssh-agent -s)
    - echo "\$DEPLOY_KEY" | ssh-add -
    - cd gluon
    # - make manifest GLUON_BRANCH=beta GLUON_PRIORITY=0
    # - make manifest GLUON_BRANCH=stable GLUON_PRIORITY=7
    - touch output/images/sysupgrade/beta.manifest
    - touch output/images/sysupgrade/stable.manifest
    # - mkdir -p ../public/${CI_COMMIT_REF_SLUG}
    # - cp -rv output/images/ ../public/${CI_COMMIT_REF_SLUG}
    - mv output $UPLOADTAG
    - find $UPLOADTAG -maxdepth 2
    - ln -s ./$UPLOADTAG ./latest
    - rsync -rvhl ./$UPLOADTAG \${DEPLOY_USER}@\${DEPLOY_HOST}:data/
    - rsync -rvhl ./latest \${DEPLOY_USER}@\${DEPLOY_HOST}:data/
EOF

done
