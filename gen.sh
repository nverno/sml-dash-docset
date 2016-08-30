#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)"
pushd "$DIR">/dev/null

docset=standardml.docset
outdir=_output/$docset/Contents/Resources/Documents

mkdir -p "$outdir"

# download manpages
if [ ! -f "$outdir/index.html" ]; then
    ./fetch.bat "$outdir"
fi

cp build/Info.plist _output/$docset/Contents/Info.plist
cp build/logo.png _output/$docset/icon.png

# parse
if ! gem list | grep sqlite3 ; then
    gem install sqlite3 --platform=ruby -- \
        --with-include-dir=c:/msys/mingw64/include \
        --with-lib-dir=c:/msys/mingw64/lib
fi

ruby test.rb
rm test.db

popd>/dev/null
