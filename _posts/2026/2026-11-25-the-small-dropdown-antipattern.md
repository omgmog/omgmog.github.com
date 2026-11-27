---
title: The small dropdown antipattern
comments_issue: 176
syndication:
  - https://indieweb.social/@omgmog/117682392622150405
  - https://social.omgmog.net/2026/new-blog-post-the-small-dropdown-antipatternpostthe-small-dropdown-antipattern
category: design
tags: [ux, design, web-development, forms]
code_demo: true
---

I've built a lot of forms over the years, and I keep running into the same antipattern. Three options in a dropdown. Sometimes _two_. I've seen Yes/No dropdowns in production code.

It drives me up the wall. A dropdown takes three interactions (click to open, scan the list, click your choice). Radio buttons take one, because the options are already on the page.

But dropdowns are still everywhere, and they cost more than patience. [UX debt wears down trust and efficiency](https://www.stauffer.com/news/blog/ux-debt-is-killing-your-bottom-line-lets-help-you-pay-down-that-debt), and people who give up on a clumsy form may not come back, even after you've fixed it.

<!-- more -->

## Hiding the options

What I can't get past is that a dropdown shows you one option and makes you ask for the rest.

{% capture dropdown_demo %}
<!-- Dropdown: only one option visible -->
<label for="size-select">Size</label>
<select id="size-select" name="size">
  <option>Small</option>
  <option>Medium</option>
  <option>Large</option>
</select>
{% endcapture %}
{% include posts/code-demo.html code=dropdown_demo %}

Radio buttons put all of it on the page. If you're choosing between three things, why hide two of them?

{% capture radio_demo %}
<!-- Radio buttons: all options visible -->
<fieldset>
  <legend>Size</legend>
  <input type="radio" name="size" value="small" id="size-s">
  <label for="size-s">Small</label>

  <input type="radio" name="size" value="medium" id="size-m">
  <label for="size-m">Medium</label>

  <input type="radio" name="size" value="large" id="size-l">
  <label for="size-l">Large</label>
</fieldset>
{% endcapture %}
{% include posts/code-demo.html code=radio_demo %}

It carries on after you've chosen, too. Once you pick from a dropdown the alternatives disappear again, so changing your mind means reopening it and remembering what else was in there. With radio buttons the selection sits next to the other options, and changing your mind is one click.

I think of this as interaction debt. Every unnecessary click is interest on a UX decision somebody made months or years ago. Nielsen Norman Group calls it "[interaction cost](https://www.nngroup.com/videos/interaction-cost/)", the sum of the effort someone has to put in to get what they want. A dropdown costs two extra steps over radio buttons, which doesn't sound like much until you multiply it. A checkout form with three small dropdowns costs six extra steps per purchase. A settings page with five costs ten.

## Two options, or five

The Yes/No dropdown is the one that gets me most. Two options should never be a dropdown.

{% capture yesno_dropdown %}
<fieldset>
  <legend>Do the thing?</legend>
  <select name="yesno_dropdown">
    <option value="yes">Yes</option>
    <option value="no">No</option>
  </select>
</fieldset>
{% endcapture %}
{% include posts/code-demo.html code=yesno_dropdown %}

That's one answer hidden behind a click, for a question that only has two. As radio buttons, both are right there:

{% capture yesno_radio %}
<fieldset>
  <legend>Do the thing?</legend>
  <input type="radio" name="yesno_radio" value="yes" id="yesno_radio-yes">
  <label for="yesno_radio-yes">Yes</label>

  <input type="radio" name="yesno_radio" value="no" id="yesno_radio-no">
  <label for="yesno_radio-no">No</label>
</fieldset>
{% endcapture %}
{% include posts/code-demo.html code=yesno_radio %}

If it's really a single yes or no, a checkbox is better still:

{% capture dothing_checkbox %}
<fieldset>
  <legend>Do the thing?</legend>
  <input type="checkbox" name="dothing_checkbox" id="dothing_checkbox">
  <label for="dothing_checkbox">Yes, do the thing</label>
</fieldset>
{% endcapture %}
{% include posts/code-demo.html code=dothing_checkbox %}

And if the change should happen straight away, use a switch:

{% capture dothing_switch %}
<!-- role="switch" changes what screen readers announce, it needs CSS to look like a toggle -->
<input type="checkbox" role="switch" name="dothing_switch" id="dothing_switch">
<label for="dothing_switch">Do the thing</label>
{% endcapture %}
{% include posts/code-demo.html code=dothing_switch %}

Which of the three depends on what the control does. A switch (like [Material Design's toggles](https://m3.material.io/components/switch/overview)) suits something that applies immediately, like WiFi, dark mode or notifications, because its position shows the current state. A checkbox suits a form where nothing happens until you press Submit. Radio buttons are better when both answers need to be visible, or when it isn't an on/off choice at all: "Preferred contact: Email / Phone" reads more clearly as radio buttons than "Contact me by phone" does as a checkbox. Any of them beats a two-option dropdown.

Small sets that people need to compare are the same story. Sizes are the obvious one, because you want to see where yours sits against the others. Delivery options are another, since people are weighing cost against speed (Standard 3-5 days, Express 1-2 days, Overnight, Same Day) and can't do that if they can only see one at a time.

{% capture delivery_demo %}
<fieldset>
  <legend>Delivery</legend>
  <input type="radio" name="delivery" value="standard" id="del-standard">
  <label for="del-standard">Standard (3-5 days)</label>

  <input type="radio" name="delivery" value="express" id="del-express">
  <label for="del-express">Express (1-2 days)</label>

  <input type="radio" name="delivery" value="overnight" id="del-overnight">
  <label for="del-overnight">Overnight</label>

  <input type="radio" name="delivery" value="sameday" id="del-sameday">
  <label for="del-sameday">Same Day</label>
</fieldset>
{% endcapture %}
{% include posts/code-demo.html code=delivery_demo %}

Keyboard users get a better deal from radio buttons too. You tab to the group, then use the arrow keys to choose. A dropdown often needs tab to focus it, space or enter to open it, arrows to move and enter to confirm (some desktop browsers let the arrow keys change a closed dropdown, but not all do), which is more keystrokes and more chances to get lost. Screen readers read out the group's legend and let you move through the options in context, where a dropdown is wordier and clunkier.

{% capture fieldset_demo %}
<!-- Keyboard users can: -->
<!-- 1. Tab to the radio group -->
<!-- 2. Use arrow keys to select -->
<!-- 3. Space to select if needed -->
<fieldset>
  <legend>Choose your subscription</legend>
  <input type="radio" name="plan" value="free" id="plan-free">
  <label for="plan-free">Free</label>

  <input type="radio" name="plan" value="pro" id="plan-pro">
  <label for="plan-pro">Pro</label>

  <input type="radio" name="plan" value="enterprise" id="plan-ent">
  <label for="plan-ent">Enterprise</label>
</fieldset>
{% endcapture %}
{% include posts/code-demo.html code=fieldset_demo %}

## Multi-select, and the workarounds

Multi-select dropdowns are worse again. Nobody knows how to use them. Is it Ctrl+click? Shift+click? Both?

{% capture multiselect_demo %}
<!-- This is confusing for users -->
<label for="features-select">Features</label>
<select id="features-select" name="features" multiple>
  <option>Feature 1</option>
  <option>Feature 2</option>
  <option>Feature 3</option>
</select>
{% endcapture %}
{% include posts/code-demo.html code=multiselect_demo %}

I've watched people try. They click one option and it selects. They click another and the first one deselects. They try Ctrl+click, which does nothing because they're on a Mac, then Cmd+click, which maybe works, and then they give up. Checkboxes would have been fine, because at least everyone understands checkboxes.

{% capture checkboxes_demo %}
<!-- Much clearer for users -->
<fieldset>
  <legend>Features</legend>
  <input type="checkbox" name="features" value="1" id="feat-1">
  <label for="feat-1">Feature 1</label>

  <input type="checkbox" name="features" value="2" id="feat-2">
  <label for="feat-2">Feature 2</label>

  <input type="checkbox" name="features" value="3" id="feat-3">
  <label for="feat-3">Feature 3</label>
</fieldset>
{% endcapture %}
{% include posts/code-demo.html code=checkboxes_demo %}

Some designers reach for "listboxes", which are a `<select>` with the `size` attribute set so several options show at once.

{% capture listbox_demo %}
<!-- Single-select listbox -->
<label for="option-listbox">Option</label>
<select id="option-listbox" name="option" size="5">
  <option>Option 1</option>
  <option>Option 2</option>
  <option>Option 3</option>
</select>
{% endcapture %}
{% include posts/code-demo.html code=listbox_demo %}

A single-select listbox is just a visible dropdown. That's better than a hidden one, but still worse than radio buttons for a small list. Listboxes are nearly impossible to style the same across browsers and look out of place in most interfaces, and they take up as much vertical space as radio buttons, or more.

{% capture listbox_multiple_demo %}
<!-- Multi-select listbox -->
<label for="options-listbox">Options</label>
<select id="options-listbox" name="options" size="5" multiple>
  <option>Option 1</option>
  <option>Option 2</option>
  <option>Option 3</option>
</select>
{% endcapture %}
{% include posts/code-demo.html code=listbox_multiple_demo %}

The multi-select version beats a multi-select dropdown because the options are visible, but checkboxes beat both for small lists. It has the same styling problems, and people still need to know about Ctrl+click. I'd save it for multi-select lists of 15 or more options.

The other way out is to replace the native `<select>` with a JavaScript component (React Select, a custom Vue dropdown) to get control over the styling. That means a bigger bundle and usually a few accessibility problems to fix. [Baymard found that 31% of the big e-commerce sites with custom-designed dropdowns at checkout had significant usability problems with them](https://baymard.com/blog/custom-dropdowns-cause-issues). If the options are going to be visible anyway, radio buttons are simpler and already accessible.

Component libraries make this easy to get wrong. Material UI, Radix, Chakra and Ant Design all ship a polished Select, so it's one import away, and I've seen developers reach for `<Select>` for three options because it looked good in the library's docs. Radio buttons need a bit of custom styling to match the design system, so the dropdown is the easy option and the worse one.

## Where I've watched it fail

Take the game filters on the casino sites I worked on, which all put their own skin on the same core UX. Five dropdowns, for game type, provider, theme, features and volatility. To find "high volatility slots with free spins," users needed to click through all five. Most gave up after the second one.

We replaced them with visible filters (radio buttons for volatility, checkboxes for features) and people started using combinations we'd never seen before. Nothing about the filtering had changed. They could just see what was possible now.

Then there were the account settings forms, which designers loved for how tidy the dropdowns looked. Three options for notification frequency, two for email format, four for language preference. They all looked the same and showed one value each, so checking what you'd set meant opening them one at a time. Radio buttons put every setting on the page at once.

The cashier had its own version of this. Registering a card was one short form with three dropdowns on it, for the card type and the expiry month and year. It looked roughly like this:

{% capture card_before %}
<form>
  <label for="legacy-card-type">Card type</label>
  <select id="legacy-card-type" name="card_type">
    <option>Visa Credit</option>
    <option>Visa Debit</option>
    <option>Mastercard</option>
    <option>Maestro</option>
  </select>

  <label for="legacy-card-number">Card number</label>
  <input type="text" id="legacy-card-number" name="card_number">

  <label for="legacy-expiry-month">Card expiry</label>
  <select id="legacy-expiry-month" name="expiry_month">
    <option value="">Month</option>
    <option>01</option><option>02</option><option>03</option><option>04</option>
    <option>05</option><option>06</option><option>07</option><option>08</option>
    <option>09</option><option>10</option><option>11</option><option>12</option>
  </select>
  <select id="legacy-expiry-year" name="expiry_year" aria-label="Expiry year">
    <option value="">Year</option>
    <option>2026</option><option>2027</option><option>2028</option>
    <option>2029</option><option>2030</option><option>2031</option>
  </select>

  <label for="legacy-card-name">Name on card</label>
  <input type="text" id="legacy-card-name" name="card_name">
</form>
{% endcapture %}
{% include posts/code-demo.html code=card_before %}

Here's how I'd build it now. The card types are a handful of options, so they become radio buttons, and the two expiry dropdowns become a single field that a phone or a password manager can fill in for you.

{% capture card_after %}
<form>
  <fieldset>
    <legend>Card type</legend>
    <input type="radio" name="card_type" value="visa-credit" id="card-visa-credit">
    <label for="card-visa-credit">Visa Credit</label>

    <input type="radio" name="card_type" value="visa-debit" id="card-visa-debit">
    <label for="card-visa-debit">Visa Debit</label>

    <input type="radio" name="card_type" value="mastercard" id="card-mastercard">
    <label for="card-mastercard">Mastercard</label>

    <input type="radio" name="card_type" value="maestro" id="card-maestro">
    <label for="card-maestro">Maestro</label>
  </fieldset>

  <label for="card-number">Card number</label>
  <input type="text" id="card-number" name="card_number" inputmode="numeric" autocomplete="cc-number">

  <label for="card-expiry">Card expiry</label>
  <input type="text" id="card-expiry" name="card_expiry" placeholder="MM / YY" inputmode="numeric" autocomplete="cc-exp">

  <label for="card-name">Name on card</label>
  <input type="text" id="card-name" name="card_name" autocomplete="cc-name">
</form>
{% endcapture %}
{% include posts/code-demo.html code=card_after %}

Most card forms these days work out the card type from the number, which is better again, but nothing on the second form hides anything behind a click, and that's the point.

If you'd like the slash to appear as you type, that's input masking, and HTML doesn't have it. `pattern` only validates, and `type="month"` falls back to a plain text box in Firefox and Safari on desktop. A mask means JavaScript, either a small script of your own or a masking library, so it's worth asking whether you need one. Without a mask people will type 1128 as often as 11/28 (the iOS number pad has no slash), so the server should accept both either way. A placeholder showing the format does most of the work.

## On a phone

On mobile, a dropdown hands over to the OS picker, which is a wheel that slides up from the bottom on iOS and a dialog with a list on Android. The native pickers work well, with familiar patterns and good touch targets, but a carefully styled dropdown turns into the system picker, which looks nothing like the rest of the interface.

Worse, [Android's full-screen picker can hide the label](https://pauljadam.com/demos/select-android.html). When the modal appears, people can't see what they're choosing. The workaround is a `selected disabled` first option that repeats the label text, just to preserve basic accessibility. Radio buttons don't need hacks like that.

[Chrome 135+ introduced customizable selects](https://developer.chrome.com/blog/a-customizable-select) to solve this, with full CSS control over how a `<select>` looks, including animations and even [bottom sheets on mobile](https://frontendmasters.com/blog/custom-select-that-comes-up-from-the-bottom-on-mobile/). Support is uneven, though. [Safari is adding it in version 27](https://webkit.org/blog/18117/the-golden-rule-of-customizable-select/) and Firefox doesn't have it yet, so those browsers fall back to the native picker.

Even with perfect styling and cross-browser support, a customised select still hides the options. Radio buttons stay in the page, and with the label as part of the click target they're easy to make a comfortable touch target (Apple suggests 44px, and WCAG 2.2 asks for at least 24px). They look like the rest of the interface too. If custom styling matters but you want the native picker, use a ["shell" pattern](https://baymard.com/blog/custom-dropdowns-cause-issues), a dropdown that looks custom but opens the native picker when clicked.

The platforms themselves avoid dropdowns for small sets. iOS and Android both use segmented controls for 2-4 options, which are basically styled radio buttons that show every choice at once in less space.

## When a dropdown is fine

I'll happily use one in a few cases. The obvious one is a long list where comparison doesn't matter, like countries (200+), named city and region timezones (the IANA list is around 400), or birth years going back to 1920. Those want search or autocomplete too, because scrolling through 200 countries is miserable.

The other is a strong default. If 90% of people want the same option, a dropdown with it pre-selected works, and the alternatives are still there, one click further down. "United Kingdom" for a UK-based service is the usual example, since most people won't change it and the ones who need to will open the list.

{% capture country_demo %}
<!-- Shortened: a real list has 200+ countries -->
<label for="country-select">Country</label>
<select id="country-select" name="country">
  <option value="au">Australia</option>
  <option value="ca">Canada</option>
  <option value="ie">Ireland</option>
  <option value="nz">New Zealand</option>
  <option value="gb" selected>United Kingdom</option>
  <option value="us">United States</option>
</select>
{% endcapture %}
{% include posts/code-demo.html code=country_demo %}

That works because there's a strong default and the list is long. For 3-4 countries, radio buttons. Be careful with pre-selecting though, because it causes errors when people rush through a form and assume the dropdown already has the right value. It's often safer to show an error for not choosing than to submit the wrong option.

Then there are options that come from somewhere else. When a CMS or a database decides what goes in the list, the same field might have three options on one site and 300 on another, and a dropdown is the one control that copes with both. I suspect that's how a lot of three-option dropdowns end up in production: the component was built for the long case and nobody went back for the short one. The fix is to make the choice when the page renders. I've built Angular components that do this, switching to a radio group when there are only a few options and a select when there are more:

{% raw %}
```html
<!-- Select for more than 3 options -->
<mat-form-field *ngIf="options.length > 3">
  <mat-label>Select an option</mat-label>
  <mat-select [(ngModel)]="selected">
    <mat-option *ngFor="let option of options" [value]="option.code">{{ option.text }}</mat-option>
  </mat-select>
</mat-form-field>

<!-- Radio buttons for 3 or fewer -->
<mat-radio-group [(ngModel)]="selected" *ngIf="options.length <= 3">
  <mat-radio-button *ngFor="let option of options" [value]="option.code">{{ option.text }}</mat-radio-button>
</mat-radio-group>
```
{% endraw %}

The threshold in that example is three, but it's a judgement call, and my rule of thumb below goes up to five.

The last case is when space is tight, like mobile filters, dense forms or inline editing in tables. Even then the constraint is often just assumed, and I've usually found more room than I thought.

My rule of thumb, from years of building forms, is radio buttons for up to five options, still radio buttons for six to ten if there's space, and a dropdown with search or autocomplete beyond that. Options people need to compare get radio buttons whatever the count, and multiple selections get checkboxes, until there are 15 or more and a multi-select listbox is fine.

I'm not the only one who thinks so. Nielsen Norman Group says that for [fewer than 5 options, radio buttons are usually better](https://www.nngroup.com/articles/dropdown-list/), because they keep every choice visible. [Smashing Magazine recommends](https://www.smashingmagazine.com/2026/02/combobox-vs-multiselect-vs-listbox/) "simple radio buttons or checkboxes" for fewer than five items. The [GOV.UK Design System](https://design-system.service.gov.uk/components/select/) discourages dropdowns for questions and suggests [a Radios component](https://design-system.service.gov.uk/components/radios/) instead, and the [BBC's design guidance](https://bbc.github.io/gel/components/filter-and-sort/) is even more direct: "Since sorting options are few in number, there's no need to obscure options inside a menu. Radio buttons are preferable, since they show all the available options simultaneously."

Radio buttons are the boring choice, but people can click once and move on. [Dropdowns should be the UI of last resort](https://www.lukew.com/ff/entry.asp?1950). If the only reason you're using one is that it looks tidier, the people filling in the form are the ones paying for it.
