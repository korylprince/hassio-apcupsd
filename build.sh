docker run --rm --privileged \
    -v ~/.docker:/root/.docker \
    homeassistant/amd64-builder \
    --all \
    -r https://github.com/korylprince/hassio-apcupsd.git \
    -b master \
    -t apcupsd
