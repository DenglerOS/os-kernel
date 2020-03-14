ARG     BASE_IMG=$BASE_IMG
FROM    $BASE_IMG AS base

RUN     apk --update --no-cache upgrade



FROM    base as ksrc

ARG     KERNEL_PKG=$KERNEL_PKG

RUN     apk --update --no-cache add \
        $KERNEL_PKG

RUN     for d in /lib/modules/*; do depmod -b . $(basename $d); done



FROM    ksrc AS build

### modules ###
COPY	files/ /

RUN     mkdir /out

RUN     /collect-modules.sh                             # ToDo: check firmware dependencies?

WORKDIR	/out

RUN	tar -cf kernel.tar .

RUN	rm -rf lib

### kernel ###
ARG	KERNEL_FILE=$KERNEL_FILE
RUN	cp -a /boot/$KERNEL_FILE /out/kernel

RUN     tar -tf kernel.tar
RUN     ls -lh



FROM    scratch

COPY    --from=build /out/ /
