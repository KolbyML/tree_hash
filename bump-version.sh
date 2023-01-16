#!/usr/bin/env bash

set -euo pipefail
set -o xtrace

crate_name=tree_hash

if [ $# -ne 2 ]
then
    echo "Usage: ./$(basename $0) <from> <to>"
    exit 1
fi

from=$1
to=$2

# sanity check
grep "^version = \"$from\"" "$crate_name/Cargo.toml" > /dev/null || (echo "Wrong version: $from" && exit 1)

# update package versions
sed -e "s/^version = \"$from\"/version = \"$to\"/" "$crate_name/Cargo.toml" -i
sed -e "s/^version = \"$from\"/version = \"$to\"/" "${crate_name}_derive/Cargo.toml" -i

# update main crate's dev dependency on derive crate (if any)
sed -e "s/\(${crate_name}_derive.*version\) = \"$from\"/\1 = \"$to\"/" "$crate_name/Cargo.toml" -i
