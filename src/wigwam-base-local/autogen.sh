#! /bin/sh

"$PLAYPEN_ROOT"/packages/wigwam-base-local/pre-build.local || exit 1
./configure || exit 1
./ww-make || exit 1
