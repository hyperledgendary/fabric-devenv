#!/usr/bin/env bash

# TBC

#
# add devenv section to .profile
#
# Note: this will remove any existing devenv section so that
# multiple 'vagrant provision' commands do not cause duplication
#
DEVENV_START_COMMENT="# ---BEGIN-FABRIC-DEVENV-PROFILE-SECTION---"
DEVENV_END_COMMENT="# ---END-FABRIC-DEVENV-PROFILE-SECTION---"

sed -i.bak "/$DEVENV_START_COMMENT/,/$DEVENV_END_COMMENT/d" ~/.profile

cat << END-PROFILE-SECTION >> ~/.profile
$DEVENV_START_COMMENT

# TBC

$DEVENV_END_COMMENT
END-PROFILE-SECTION
