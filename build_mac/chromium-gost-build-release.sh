#!/bin/sh

cd $(dirname $0)
. ./chromium-gost-env.sh
export PATH=$DEPOT_TOOLS_PATH:$PATH

cd $CHROMIUM_PATH/out/RELEASE
unlink *.tar.bz2
if [ -d Chromium.app ]; then rm -rf Chromium.app; fi
if [ -d Chromium-Gost.app ]; then rm -rf Chromium-Gost.app; fi

cd $CHROMIUM_PATH
gn gen out/RELEASE --args="is_debug=false symbol_level=0 strip_debug_info=true is_official_build=true ffmpeg_branding=\"Chrome\" proprietary_codecs=true $CHROMIUM_PRIVATE_ARGS clang_use_chrome_plugins=false closure_compile=false enable_hangout_services_extension=false enable_mdns=false enable_mse_mpeg2ts_stream_parser=true enable_nacl=false enable_nacl_nonsfi=false enable_reporting=false enable_service_discovery=false enable_widevine=true"
ninja -C out/RELEASE chrome

cd out/RELEASE

mv -f Chromium.app/Contents/MacOS/Chromium Chromium.app/Contents/MacOS/Chromium-Gost

echo "#!/bin/bash" > Chromium.app/Contents/MacOS/Chromium
echo "cd \"\${0%/*}\" && ./Chromium-Gost" >> Chromium.app/Contents/MacOS/Chromium
chmod 755 Chromium.app/Contents/MacOS/Chromium

mv -f Chromium.app/ Chromium-Gost.app/
tar -jcvf chromium-gost-$CHROMIUM_TAG-macos-amd64.tar.bz2 Chromium-Gost.app
