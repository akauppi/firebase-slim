#!/bin/bash
set -euf -o pipefail

# firebase-slim.sh
#
# Remove unnecessary files from Firebase '@exp' ("alpha"; 0.900.17) packaging.
#
# During the alpha runs, Firebase seems to pour a lot of unnecessary files to the developers. This script trims it
# down to what is actually needed.
#
# Why this matters?
#   - disk space
#   - download bandwidth; the environment
#   - easier to study the code when cruft is out
#   - IDE indexing may be faster
#


#--- node_modules/firebase
#
# This folder is simply a proxy to `@firebase/xxx` subpackages. It should not weigh much.
#
# Initial:  18MB
# Reached:  128KB
#
DIR=node_modules/firebase

# rm *.cjs.*
#
find $DIR -name "*.cjs.*" | xargs echo rm -f

# rm firebase/*/dist/* where the two folder names aren't the same
#
# (all the types are repeated for each subpackage, though only one of them is important)
#
# Note: Not listing the subdirs, since 'compat' seems to be different.
#
for x in analytics app auth database firestore functions messaging performance remote-config storage; do
  find $DIR/$x/dist -type d -depth 1 ! -name $x | xargs echo rm -rf
done

# rm firebase/firestore/lite/dist/* where '*' is not 'firestore'
#
find $DIR/firestore/lite/dist -type d -depth 1 ! -name 'firestore' | xargs echo rm -rf

# rm firebase/*.js
#
# (what are they for? folders like 'firebase/analytics' are used, right?)
#
(ls $DIR/*.js $DIR/*.js.map 2>/dev/null || true) | xargs echo rm -f

#--- node_modules/@firebase
#
# These are the real implementations.
#
# Initial:  47MB
# Reached:  ...
#
DIR=node_modules/@firebase

# rm *.cjs.*
#
find $DIR -name "*.cjs.*" | xargs echo rm -f

# rm 'src', 'test', 'testing' subdirs
#
find $DIR \( -name "src" -or -name "test" -or -name "testing" \) | xargs echo rm -rf

# rm 'esm5' (there is no such thing)
#
# The folders having such files also have "esm2017" or plain ESM.
#
find $DIR \( -name "*.esm5.js" -or -name "*.esm5.js.map" \) | xargs echo rm -f
find $DIR -name "esm5" | xargs echo rm -rf

# Cordova, React Native (rn), Web worker
#
# Do they really need their own packaging??
#
find $DIR \( -name "cordova" -or -name "rn" \) | xargs echo rm -rf
find $DIR \( -name "*.cordova.*" -or -name "*.rn.*" \) | xargs echo rm -f

# "Scripts"
#
find $DIR -name "scripts" | xargs echo rm -rf


# Empty folders, at least after the above cleanups.
#
find $DIR/app/dist -name "packages-exp" | xargs echo rm -rf

# Not quite sure of these
#
# find $DIR/database/dist/exp -depth 1 -name exp | xargs echo rm -rf
# find $DIR/firestore -depth 1 -name bundle | xargs echo rm -rf
find $DIR -name "*.sw.*" | xargs echo rm -f



# OPTIONAL: Web worker
#
# Does it need its own packaging??
#
# find $DIR -name "*.webworker.*" | xargs echo rm -f


# OPTIONAL: Node
#
# Does it need its own packaging??
#
# find $DIR -name "*.node.*" | xargs echo rm -f
# find $DIR -name "node" | xargs echo rm -rf


# OPTIONAL: Remove '.esm.js' (where there is '.esm2017.js')
#
#   It may be good to ship both ESM and ESM2017. These represent different maturity levels in browsers.
#
# find $DIR/analytics $DIR/component $DIR/database \( -name "*.esm.js" -or -name "*.esm.js.map" \) | xargs echo rm -f

# find $DIR/app-compat -name "*.lite.js" | xargs echo rm -f



# the end

