---
title: Compressing PDF files from your Mac or Linux terminal with Ghostscript
comments_issue: 90
tags: [guide]
---
I arrived at this solution recently when looking to compress a massive print-quality PDF for the web.

If you search for "compressing pdf files on mac" you'll get lots of bad results. There are lots of paid applications out there that claim to be able to do this, but they're (obviously) not free.

<!-- more -->

If you're not afraid to get your hands dirty in the terminal you can compress your PDF files from your terminal with a single command. If you find youself needing to do this often, I've got a function that I put together to make this easier.

The method I'm using requires `ghostscript`. Ghostscript is a high quality, high performance Postscript and PDF interpreter and rendering engine [[1]](http://ghostscript.com/FAQ.html).

If you're using a Mac, you can install `ghostscript` using `brew`:

```bash
brew install ghostscript
```

If you're using Linux you can install `ghostscript` from `aptitude`, or your package manager of choice [[2]](https://gist.github.com/leomelzer/3949356).

Now, you can use `ghostscript` to compress your PDF file for the web:

```bash
gs -sDEVICE=pdfwrite -dNOPAUSE -dQUIET -dBATCH -dPDFSETTINGS=/screen -dCompatibilityLevel=1.4 -sOutputFile=output.pdf input.pdf
```

That's not exactly a memorable command, so I've made a function that you can add to your `~/.bash_profile` to allow you to easily compress PDF files from your terminal:

```bash
# Usage: compresspdf [input file] [output file] [screen*|ebook|printer|prepress]
compresspdf() {
    gs -sDEVICE=pdfwrite -dNOPAUSE -dQUIET -dBATCH -dPDFSETTINGS=/${3:-"screen"} -dCompatibilityLevel=1.4 -sOutputFile="$2" "$1"
}
```

Now you can simply run the following command:

```bash
compresspdf "Massive.pdf" "Small.pdf"
```

Using this command I managed to compress an A3 size PDF (originally around 9MB) down to just under 1MB, which is perfect for the web.
