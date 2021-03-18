# firebase-slim

A script to show how the Firebase "alpha" packaging can be slimmed down, without affecting features.

The script does **not** make changes to your local files. It provides you the commands you need to execute yourself.

In this code, only ES modules based browser targets are left (node.js, Cordova, CommonJS removed). You can tune this by commenting out sections in the script, if you wish. The author was only interested in targeting the latest browsers (native ESM support).

Potential for size reduction:

||before|after|
|---|---|---|
|`firebase`|18M|216K (-98.8%)|
|`@firebase`|||
|with dependencies|||


## Why do this?

I [recently noticed](https://github.com/firebase/firebase-js-sdk/discussions/4588#discussioncomment-469743) that the `node_modules/@firebase` files were 128 MB in size.<sub>That number may have been a mistake, in retrospect</sub> This script removes pieces of them, one by one, as long as my web app continues to function.

## Using it

>NOTE: Be prepared to restore your Firebase package, if too much gets removed.

Within one's app repo, run the script:

```
$ <path to>/firebase-slim.sh
```

Execute the listed commands - at your own risk!! - to slim.

Try, whether your app still builds and works.


<!-- disabled
## Results

### Initial

```
$ du -h node_modules/firebase
...
 18M	node_modules/firebase
```

These files are only proxies to `@firebase`. They should be feather weight.

```
$ du -h node_modules/@firebase
...
 47M	node_modules/@firebase
```

hmm... that's not 128M.
 
With all the dependencies as well:

```
$ du -h node_modules
...
 80M	node_modules
```
-->

