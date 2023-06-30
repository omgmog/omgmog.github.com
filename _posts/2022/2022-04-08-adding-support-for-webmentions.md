---
title: Adding support for Webmentions
comments_issue: 114
tags: [indieweb]
syndication:
  - https://indieweb.social/@omgmog/108203284974135392
---

I've added [Webmention](https://indieweb.org/Webmention) support to the posts on this blog.

Webmentions are a method for websites to know that they've been linked to (or mentioned) from elsewhere on the web.

<!-- more -->

> **[Webmention](https://www.w3.org/TR/webmention/)** is a web standard for mentions and conversations across the web, a powerful building block that is used for a growing federated network of comments, likes, reposts, and other rich interactions across the decentralized social web.
>
> When you link to a website, you can send it a Webmention to notify it. If it supports Webmentions, then that website may display your post as a comment, like, or other response, and presto, you're having a conversation from one site to another!

It depends on a couple of things being in place for it all to work, but I've implemented the basics to fetch and display any mentions that have been detected by the [webmention.io](https://webmention.io) service.

I have already been using Github Issues-powered commenting for the past couple of years, so I took the time to consolidate comments and Webmentions in to a single chunk of "interactions" functionality to fetch, cache, and render any comments or Webmentions. This is all done with native JS and could probably be improved further with a framework like Vue.js, but it works fine for now.

I'm using [brid.gy](https://brid.gy) to recieve Webmentions from Twitter and Reddit interactions via [webmention.io](https://webmention.io) — this will mean that if somebody shares/likes/retweets a link to one of my blog posts on either platform it will display that here below the post.

I'm using [webmention.app](http://webmention.app) and [IFTTT](https://ifttt.com) to automatically try and send webmentions to sites I link to from within my posts.

As you can see it's a bit complicated, and it feels like it's held together with duct tape in places, but for now it works!

Lots of others have written about how they've implemented Webmentions on their sites, and these write-ups were really useful when arriving at my own implementation.

So to share the love, here are some links to those posts:

- [Webmentions - Phil Gyford](https://www.gyford.com/phil/writing/2022/03/30/webmentions/)
- [Webmentions for your Static Site - Rowan Manning](https://rowanmanning.com/posts/webmentions-for-your-static-site/)
- [Using Web Mentions in a static site (Hugo) - Paul Kinlan](https://paul.kinlan.me/using-web-mentions-in-a-static-sitehugo/)
- [Adding Webmention Support to a Static Site - Keith J. Grant](https://keithjgrant.com/posts/2019/02/adding-webmention-support-to-a-static-site/)
- [Adding Webmentions to My Static Hugo Site - Ana Ulin](https://anaulin.org/blog/adding-webmentions/)
- [Using Webmentions in Eleventy - Max Böck](https://mxb.dev/blog/using-webmentions-on-static-sites/)
- [Webmentions: Enabling Better Communication on the Internet - Chris Aldrich](https://boffosocko.com/2018/07/19/webmentions-enabling-better-communication-on-the-internet-2/)
- [Add Webmention support to your website in ten minutes - Daniel Aleksandersen](https://www.ctrl.blog/entry/setup-webmention.html)
- [Sending your First Webmention from Scratch - Aaron Parecki](https://aaronparecki.com/2018/06/30/11/your-first-webmention)
- [Implementing Webmention on a static website - Deluvi](https://deluvi.com/blog/webmention/)
- [Adding Webmention Support from Scratch - Dwayne Harris](https://dwayne.xyz/post/webmentions-from-scratch)
- [Social media responses on a Jekyll site using webmentions - James Dinsdale](https://molovo.co/writing/jekyll-webmentions/)
- [Adding webmentions to my blog - Sebastian De Deyne](https://sebastiandedeyne.com/adding-webmentions-to-my-blog/)
- [A Brief Look at WebMention - Ben Shi](https://hbish.com/brief-look-at-webmention/)
- [IndieWebify.Me](https://indiewebify.me)

And that's about it really. I'll be tweeting a link to this post once it's published and then any replies or likes will _hopefully_ appear at the bottom of the page.
