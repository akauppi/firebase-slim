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
# Reached:  ...
#
DIR=node_modules/firebase

# rm *.cjs.*
#
# CommonJS not needed
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
ls $DIR/*.js $DIR/*.js.map 2>/dev/null | xargs echo rm -f

#echo rm -f $DIR/*.js $DIR/*.js.map

#---

#
# POP=$(pwd)
# #cd node_modules/@firebase
#
# echo "# Commands to execute, to skin down 'node_modules/@firebase"
# echo "#"
#
# #--- Directories ---
#
# #./database/exp-types
# #./firestore-types
# #./storage-types
# #./app-types
# #./auth-interop-types
# #./messaging-types
# #./database-types
# #
# #find . -name "*-types" | xargs echo "rm -rf"
#
# # src, test, testing
# find . -name "src" | xargs echo "rm -rf"
# find . -name "test" | xargs echo "rm -rf"
#
# # anything 'esm5', 'cordova', 'webworkers', 'rn' (React Native)
# # node-cjs
#
# # anything "*compat", "lite"
#
# # node_modules
#
# #--- Files ---
#
# # *.rn.* (maps)
# # *.esm5.*
# # *.cjs
#
#
# cd $(POP)
#
# du -h node_modules/@firebase
#
#