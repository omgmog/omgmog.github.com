---
comments_issue: 39
title: Migrating from Outlook .pst to mbox and then uploading to an IMAP mail server
---
Microsoft Outlook uses a stupid/proprietary format to store mail locally. This is the burden I had to deal with recently while attempting to rescue mail from a friends dying computer.

<!-- more -->

Before I get on to the process, some background and the hurdles encountered so far:

1. The computer dying in the first place
2. The fact that this friend had 5 years of mail in their Outlook, and they're very set in their ways.
3. I haven't used Windows in depth for a couple of years.
4. Windows hides important things like Outlook datafiles in a hidden directory in `C:\Documents and Settings\User\Local Settings\Application Data\Microsoft\Outlook`
5. `.pst` files are a bit flakey and easily corrupted.
6. Five years of mail means a massive corrupted `.pst` file to deal with

To begin with I set up the friends old mail account on their new computer using `IMAP`, only to discover they had previously beeing using `POP3`, and so none of their old mail remained on the server.

Okay I thought, I can just restore the (aforementioned) `.pst` file from their old hard drive and they'll have all of their old mail.

Nope. As I mentioned, `.pst` files are easily corrupted, and so much as a misplaced bit or byte here or there will mean Outlook will refuse to open the file.

But fret not, Microsoft provide a tool to fix `.pst` files!.. But it's hidden away in the hard drive somewhere -- in fact, it's in a different location for each version of Office. I was working with an old computer running Windows XP, and Office 2003, so for me `scanpst.exe` was in `C:\Program Files\Common Files\System\Mapi\1033\SCANPST.EXE`.

ScanPST takes ages to scan a five-year-old 7000+ email inbox, on an old computer running Windows XP.

After it had finished scanning, and it told me that one or two bits and bytes had gotten misplaced, I started to import it in to Outlook. After what seemed like a further age, Outlook decided that it didn't like this `.pst` file actually, and threw its toys out of the pram.

So now Outlook was broken.

{% include posts/figure.html src="clintspencer,%20Image%20%233237600%20.jpeg" %}{:.massive.center}

After a couple of hours of furiously deleting rogue `.pst` files, removing accounts by, and I quote Microsoft here, "[Clicking] the Mail icon in Control Panel" -- yes, no-where near Outlook, but in a (meta-)directory tied to the Operating System -- I managed to get Outlook up and running again, with IMAP access to the mail account, but still no old emails.

## How to get those old emails out of the `.pst` file and in to IMAP:

It's quite a simple process, and unmistakably faster than trying to use ScanPST and loading in to Outlook. The overview is:

1. Convert the `.pst` file to a more universally accepted `mbox` using `libpst`
2. Take the the `mbox` and push it directly to the `IMAP` server.
3. Cry with joy as you see Outlook downloading the old messages from the `IMAP` server before your eyes.

One caveat here is that we're effectively sending the mail from our hard drive to the remote `IMAP` server, and then having Outlook re-download it.

This wasn't a problem for me as it meant I could do the conversion and pushing from my own computer in my own home, and then the friend could download the messages on their end, on their computer.


## Converting Outlook PST file to mbox

These instructions are Mac-oriented, but they should be applicable to any \*NIX system

If you've recently upgraded `Xcode`, or haven't yet installed it, you will need to accept the new terms and conditions before this will work

```bash
# Installing Xcode command-line tools if you don't have them (gcc and stuff)
$ xcode-select --install
# Accepting terms and conditions for xcode
$ sudo xcodebuild -license
```

Install `libpst` using [Homebrew](http://brew.sh/):

```bash
$ brew install libpst
```

Convert your `.pst` to a `mbox`

```bash
$ cd <location of your .pst file>
$ mkdir mbox
$ readpst -o mbox -r <your pst file>.pst
```

## Uploading your mbox to your IMAP server

Download `imap_upload.py` from [http://imap-upload.sourceforge.net/](http://imap-upload.sourceforge.net/), and put `imap_upload.py` in the directory with your `.pst` files.

Upload the folders you want to your `IMAP` server

```bash
$ python imap_upload.py --host <imap server address> --box <remote folder> <local mbox>
```

In my case I did the following:

```bash
$ python imap_upload.py --host imap.1and1.co.uk --box Inbox mbox/personal/Inbox/mbox
```

You will be prompted to log in with your `IMAP` account name and password. If you have any problems, the `imap_upload.py` script also accepts `imap://` urls, and `--port`, etc. You can read more about the options on [http://imap-upload.sourceforge.net/](http://imap-upload.sourceforge.net/), or by running `imap_upload.py --help`.

You can do this for each folder that you would like to upload.

If it all goes well you should see it first count the number of emails and then push them one by one to the server.
