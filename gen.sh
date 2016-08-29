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


popd>/dev/null
