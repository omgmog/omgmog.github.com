---
comments_issue: 76
title: 'Adventures in IMAP: Migrating lots of mail to Atmail'
---
Besides my day job as a front-end developer at [2degrees](http://2degreesnetwork.com), I run my own web design company with my partner, called [Marmalade &amp; Jam](http://marmaladeandjam.co.uk).

When launching Marmalade &amp; Jam, I decided to go with 123-reg as I needed a quick way to get everything up and running, and at the time they seemed like a good deal.

<!-- more -->

I setup a handful of our clients on 123-reg, migrating a couple of our inherited clients over from Bluehost, and immediately found an issue with the mail service that 123-reg provided -- They don't have the capability to let you set a single email address as an inbox and a forwarder.

As I didn't want to have to mess our clients around (having already migrated them to 123-reg) I set the mail up to have one address that acts as a forwarder, and one address as an inbox (which the forwarder would send to, as well as to any other addresses).

This _worked okay_ for a while, but ultimately it wasn't the best way to do things, and I had to find a better, more managable, solution for any newer clients.

In the end, I decided to rent a VPS and set up my own Postfix/Dovecot mail server. This worked great for me as I liked having full control over the whole thing, and even though it was a bit of a steep learning experience to setup, it worked out well in the end. Sort of.

The problems I had with running my own Postfix mail server included most of the following:

- Even with clear/concise instructions on how to setup IMAP, customers still failed to set it up correctly on their end
- Squirrel Mail as a webmail client sucks
- Settings up SSL certificates is a pain
- For some reason incoming/outgoing mail was being greylisted all the time, causing delays in delivery (and for one customer a missed meeting!)

So I had to find a better solution. As it turned out, the latest of those problems co-incided with it being time to renew my annual subscription on 123-reg.

Along with the issues with 123-reg mail, I decided it would be better to host the websites elsewhere, so I transitioned to using a [Linode VPS](http://www.linode.com/?r=99ca38bfbf1c8c22e3e88622fa6b62b3ee3f5993) for all of my web hosting needs, and that has worked wonderfully.

Back to the mail, I decided to move from my own Postfix mail server, to using a hosted "pay per inbox" solution elsewhere. The Postfix maintenance/debugging/complaints overhead was too much for me, and the final product was only as polished as I could make it, so I decided to switch to [Atmail Cloud](http://atmail.com/cloudnow/). They provide a 14-day trial which was perfect for me to test that it could do everything I needed, and within 2 days I had all of the 20 or so client inboxes **and** forwarders moved over to atmail.

That process was made a lot easier with the use of [imapcopy](https://code.google.com/p/imapcopy/), which I simply made a bash script to run it through each inbox on the old servers (123-reg and Postfix) to copy them to their new inbox on atmail:

```bash
#!/bin/bash

./imapCopy.sh imap://user1:pass1@old_mailserver imap://user1:pass1@new_mailserver
./imapCopy.sh imap://user2:pass2@old_mailserver imap://user2:pass2@new_mailserver
./imapCopy.sh imap://user3:pass3@old_mailserver imap://user3:pass3@new_mailserver
./imapCopy.sh imap://user4:pass4@old_mailserver imap://user4:pass4@new_mailserver

# ad infinitum...
```
