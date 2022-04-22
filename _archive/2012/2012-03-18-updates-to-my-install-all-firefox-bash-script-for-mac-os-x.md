---
comments_issue: 42
title: Updates to my 'install all firefox' bash script for Mac OS X
---
I wrote briefly about my [install-all-firefox shell script](/post/bash-script-to-install-all-major-versions-of-firefox-on-osx/) back in December last year. Since then the script has received a complete rewrite, and some new features.

<!-- more -->

The features of the script at the moment are as follows:

- checks for latest version of script when launched
- installs all major versions of Firefox, including Aurora/Beta/Nightly versions
- creates profiles for each version of Firefox
- modifies the .app for each version to allow multiple versions to run side-by-side, and to make them to start with their profile
- (optionally) installs Firebug for each version of Firefox

You can start using the script by running the following lines from your `terminal` on Mac OS:

```bash
$ curl -L -O https://github.com/omgmog/install-all-firefox/raw/master/firefoxes.sh
$ chmod +x firefoxes.sh
```

This will download the `firefoxes.sh` launcher part of the script so that you can execute it as below:

```bash
$ ./firefoxes.sh [version] [locale] [no_prompt]
```

## version
The `version` argument is any of the versions mentioned below (see the [github repo](https://github.com/omgmog/install-all-firefox) for the latest list of supported versions):

```text
2.0.0.20, 3.0.19, 3.5.9, 3.6.28, 4.0.1, 5.0.1, 6.0.1, 7.0.1, 8.0.1, 9.0.1, 10.0.2, 11.0, beta, aurora, nightly, ux
```

Besides these versions, the script support some additional keywords to install sets of versions, these are below:

`all, all_future, all_past, current`

## locale
The `locale` argument is any of the locales mentioned below:

```text
af, ar, be , bg, ca, cs, da, de, el, en-GB, en-US, es-AR, es-ES, eu, fi, fr, fy-NL, ga-IE, he, hu, it, ja-JP-mac, ko, ku, lt, mk, mn, nb-NO, nl, nn-NO, pa-IN, pl, pt-BR, pt-PT, ro, ru, sk, sl, sv-SE, tr, uk, zh-CN, zh-TW
```


The installation of the `Aurora` and `Nightly/UX` versions will install as `en-US` regardless of the locale you specify.

## no_prompt
The `no_prompt` argument is useful if you want to just install without any interaction necessary.  If you specify `no_prompt` all `y/n` choices (reinstall over existing Firefox versions installed by this script, install Firebug for all versions) will be answered with `y` automatically.
