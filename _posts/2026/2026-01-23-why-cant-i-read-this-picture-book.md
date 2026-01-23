---
title: "Why can't I read this picture book?"
comments_issue: 129
tags: [ux, design, accessibility]
syndication: []
header_background: "/images/2026-01/picture-books-header-alt.png"
---

I've spent the last five years reading picture books with my kids at bedtime. Hundreds of them - and I'm still going, even as my eldest moves on to chapter books. One thing has consistently driven me mad: I often can't read the words.

<!-- more -->

Books that look fine in the shop become unreadable at night. Black text on dark blues, purples, greens - whatever colour the page happens to be. I spend too many evenings squinting, tilting the book toward the light, trying to decode sentences while my tired eyes give up.

## Highlighting the problem

The worst offenders follow a predictable pattern - designers pick a colour scheme that matches the illustration, then slap black text on top without considering how anyone will actually read it. Dark blue backgrounds with black text, nearly unreadable in low light. The reverse - dark blue text on black backgrounds - is just as bad. Purple, dark green, any dark colour really.

This isn't about bad eyesight (though as I approach 40, that's increasingly relevant). Picture books are read by tired adults, in low light, often at the end of a long day. Designing for perfect vision under studio lighting misses the real use case.

The Web Content Accessibility Guidelines (WCAG) specify a minimum contrast ratio of 4.5:1 for normal text. It’s designed for screens, but screens let you zoom, boost brightness, or switch themes. Print doesn’t. If anything, print has _less_ margin for poor contrast, not more.

Here's what those contrast ratios look like in practice:

{% include posts/figure.html src="2026-01/contrast-ratios-best.png" title="Source: [https://accessiblyapp.com/web-accessibility/colors/](https://accessiblyapp.com/web-accessibility/colors/)" %}{:.center}

**One in 12 men** and **one in 200 women** have colour vision deficiency. **One in 30 people** in Europe experience some form of sight loss. Poor contrast creates accessibility problems regardless of lighting conditions. The bedtime reading scenario makes it worse.

Certain colours fail more often than others under low light. The problem with blue and purple backgrounds is luminance - these dark colours have similar luminance values to black, which shrinks the contrast between them.

Remember that dress photo from 2015?

{% include posts/figure.html src="2026-01/the-dress.jpg" %}{:.center}

The dress went viral because our brains guess the light source. Bedtime reading forces a similar guess, every night, under dim, uneven lamplight. Designers assume bright, even conditions. The colours and contrast that work in one context fail in the other.

## This isn't difficult to fix

I've spent 20 years working in interface design and web UX, so I know basic contrast principles really aren't complicated. This isn’t about killing creativity. Illustrations can be as bold and colourful as you like. That’s the point of picture books. Text just needs to be boring enough to read.

Testing designs in a dark room by bedside lamp would catch most of these problems. If it's hard to read in that light, there's a good chance the contrast's too low.

Illustrators already know how to handle nighttime scenes - they use careful colour shifts to keep illustrations visible. That same consideration needs to extend to the text.

Contrast checking tools exist - and print designers are already using the same software as web designers, just with CMYK instead of RGB. The tools are right there in the workflow. Here's how they visualise the problem:

{% include posts/figure.html src="2026-01/contrast-diagram.png" title="Source: [https://accessiblyapp.com/web-accessibility/color-contrast/](https://accessiblyapp.com/web-accessibility/color-contrast/)" %}{:.center}

These tools test combinations against 4.5:1, and greyscale testing shows whether text will work in dim light. Dark text on light backgrounds gives the best results - black on cream or off-white is easiest to read. For coloured backgrounds, luminance difference needs to stay high - a cream or off-white text box with dark text, or halos and outlines around letters when backgrounds vary. **Legibility isn't optional.**

This is fixable. It’s not a hard problem. The only real requirement is to design for where these books are actually read: dim rooms, tired parents, and small humans waiting for the next page.

---

**Further reading:**
- [Web Content Accessibility Guidelines (WCAG) 2.2](https://www.w3.org/WAI/WCAG22/Techniques/general/G18)
- [WebAIM Contrast Checker](https://webaim.org/resources/contrastchecker/)
- [Colour contrast: why does it matter?](https://accessibility.blog.gov.uk/2016/06/17/colour-contrast-why-does-it-matter/)
- [Dos and don'ts on designing for accessibility](https://accessibility.blog.gov.uk/2016/09/02/dos-and-donts-on-designing-for-accessibility/)
- [Core principles for accessible design in print](https://www.charitycomms.org.uk/core-principles-for-accessible-design-in-print)
- [Books Without Barriers (PDF)](https://www.iped-editors.org/wp-content/uploads/2024/06/Bookswithoutbarriers_Screen-2.pdf)
- [Designing beautiful and accessible UX: Colour contrast](https://bitcrowd.dev/designing-beautiful-and-accessible-ux-color-contrast/)
