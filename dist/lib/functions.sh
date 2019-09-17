sl_prepare_version() {
    vminor_t=$(printf "%02d" $vminor)
    version_t="v$vmajor.$vminor_t.$vpatch"
    version_n="$vmajor.$vminor.$vpatch"
}

sl_prepare() {
    echo "start build on $TRAVIS_OS_NAME ($BUILD_OS)"
    sed_opt="-i"

    sl_prepare_version

    mkdir -p build;
    pushd build
    mkdir -p my_include


    SHASUM=$(which shasum)
}

sl_get_openssl() {
    wget https://www.openssl.org/source/openssl-${openssl}.tar.gz
    echo "$openssl_sha256  openssl-${openssl}.tar.gz" | \
        ${SHASUM} -a 256 -c -
    tar -xzf openssl-${openssl}.tar.gz
    ln -s openssl-${openssl} openssl
}

sl_get_flac() {
    wget https://ftp.osuosl.org/pub/xiph/releases/flac/flac-${flac}.tar.xz
    tar -xf flac-${flac}.tar.xz
    ln -s flac-${flac} flac
}

sl_get_rtaudio() {
    wget https://github.com/Studio-Link/rtaudio/archive/${rtaudio}.tar.gz
    tar -xzf ${rtaudio}.tar.gz
    wget https://github.com/Studio-Link/rtaudio/compare/master...coreaudio.diff
    wget https://github.com/Studio-Link/rtaudio/compare/master...pulseaudio.diff
    pushd rtaudio-${rtaudio}
    patch --ignore-whitespace -p1 < ../master...pulseaudio.diff
    patch --ignore-whitespace -p1 < ../master...coreaudio.diff
    popd
    ln -s rtaudio-${rtaudio} rtaudio
    cp -a rtaudio-${rtaudio}/rtaudio_c.h my_include/
    rm -f ${rtaudio}.tar.gz
}
