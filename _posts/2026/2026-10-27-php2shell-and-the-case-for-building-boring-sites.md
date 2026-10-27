---
title: PHP2Shell and the case for building boring sites
comments_issue: 173
tags: [server, jekyll]
---

From Wednesday 21 October to the end of the weekend, I was patching an old VPS and moving a handful of sites onto a new one. PHP2Shell finally made the decision for me.

This blog carried on regardless, because it's just files. The sites I'd built with a CMS were another story.

<!-- more -->

I was a WordPress person long before I was a static site person. It ran my blog, and then a number of pub and company websites I built over the years as Marmalade & Jam. I never used off-the-shelf themes. I built everything custom, but the plugins were great and the editor was a lovely UI for content creation, especially for clients. By 2015 I was [tracking which sites were behind on updates in a Google spreadsheet](/post/maintaining-updates-for-a-bunch-of-wordpress-sites-with-google-spreadsheets/), which tells you how well that scaled. My own blog had already escaped by then, though.

In 2012 I moved this blog to [Jekyll](https://jekyllrb.com/) on [GitHub Pages](https://pages.github.com/). It wasn't really a security decision. I wanted my posts as plain files in a repo instead of rows in a database on a server I had to babysit, and at the time it was a great way to learn git. It also left nothing for an unauthenticated request to poke at. No PHP runtime, no database, just files.

Maintaining WordPress installs and their questionable plugins, the very thing I'd originally loved about it, became a burden over time. So I started building client websites in [Bolt CMS](https://boltcms.io/) instead. Clients managed their own menus and content, so those sites had to stay dynamic.

They sat on an old VPS, still on Bolt 2.x and PHP 7.4 on Debian 8, which was also [long out of support](https://www.debian.org/lts/security/2020/dla-2272). _Yes_, PHP 7.4 had been [end-of-life since 2022](https://www.php.net/supported-versions.php). _Yes_, I knew. I'd swapped one maintenance burden for a smaller one, and then ignored that one as well.

Then PHP2Shell landed. PHP [shipped emergency patches](https://bleepingcomputer.com/news/security/php-ships-emergency-patches-for-critical-php2shell-flaws) for two critical flaws. In theory, anyone on the internet could send a single request to a vulnerable server and run their own code on it, with no login needed. It affected nearly every way of serving PHP, and VirusTotal's estimate put over 5 million PHP hosts on the open internet. By 26 October the US CISA had [added both flaws](https://www.cisa.gov/known-exploited-vulnerabilities-catalog) to its list of known exploited vulnerabilities.

PHP 7.4 got no official release, only a [source-only patch](https://github.com/php/php-src/tree/PHP-7.4-CVE-2026-109618-109619). When exploit attempts ramped up on Wednesday night, I built it, swapped it in and went to bed.

What made that night survivable was Cloudflare. Everything runs through it. Traffic between it and the server is encrypted the whole way, and every CMS admin page sits behind [Cloudflare Access](https://developers.cloudflare.com/cloudflare-one/policies/access/) instead of the open internet. It also rolled out protections for these flaws that covered proxied PHP sites, free plans included. None of it replaces patching, but it covered the gap while I built the patch.

The proper fix was the weekend, when I built a fresh VPS on a modern OS and installed the vendor-provided patched PHP 8.5 package. Then I migrated the Bolt sites from Bolt 2.x to Bolt 6.1.9, which PHP 8.5 needed, rather than doing a straight copy.

The default vhost on the new server denies everything, and PHP runs in its own isolated pool for each site that needs it. The Bolt sites are all back up, and honestly better for it.

Some other sites only used PHP for Twig templating, and their content had remained largely unchanged since I built them. Those didn't need a new framework. I turned them into plain static HTML and moved the files across, so there's no PHP left on them for the next flaw to find. That included [uxofvr.com](https://www.uxofvr.com), which got a rebuild and a design tweak after ten years.

Putting off the server and Bolt upgrades for years was a choice. I paid for it with a weekend and roughly double the monthly bill for a month while I spun up the new [Linode](https://www.linode.com/).

Clients managing their own menus is a good reason to run a CMS, and I'd do that again. Twig templating on sites that barely change isn't. Building those as boring plain files from the start would have left nothing to patch, or to neglect.
