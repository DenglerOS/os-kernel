#!/bin/sh

set -x

SRC=${1:-""}
DST=${2:-"/out"}
KERNEL=${3:-$(ls -1 $SRC/lib/modules)}
FEATURES_DIR=${4:-$(pwd)/features}

LIBMOD=lib/modules/$KERNEL
LIST=$(cat $FEATURES_DIR/*.modules)


cd $SRC/$LIBMOD


for module in $LIST; do
	for mod in $(find $module); do
		mkdir -p $DST/$LIBMOD/$(dirname $mod)
		cp -a $mod $DST/$LIBMOD/$mod

		# handle dependencies
		for dep in $(grep ^$mod $SRC/$LIBMOD/modules.dep | cut -d: -f2); do
			mkdir -p $DST/$LIBMOD/$(dirname $dep)
			cp -a $dep $DST/$LIBMOD/$dep
		done
	done
done


cp -a $SRC/$LIBMOD/modules.* $DST/$LIBMOD/
