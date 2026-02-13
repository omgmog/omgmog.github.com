---
title: "Creating the moanlog search form with CSS"
tags: [css, tutorial]
archived: true
archive: omgmog.net
---

Styling form elements with CSS is never a fun task. Cross browser differences in how form elements are rendered, coupled with changes in font size and browser capabilities, makes predicting how a form will look, after you've applied a style to it, a hard job.

When working on the design for [moanlog](http://moanlog.com) (and the Wordpress theme for [moanblog](http://moanlog.com/blog)) the search bar was one of the areas that took the most deliberation.

{% include posts/image-lost.html %}

The search form as it looks in its finished style maintains the unified style of the soft salmon colours in the moanlog design.

<!-- more -->

## The HTML markup

```html
<form action="/search" method="get" id="searchform">
    <fieldset>
        <input id="search" name="q" type="text" value="Search" />
        <button>Search</button>
    </fieldset>
</form>
```

Pretty standard markup for a form.. You will have probably noticed that I'm using a button for the submit button, instead of another input, I'm doing this because the button element is easier to style, and for it's purpose it makes more sense.

To distinguish this particular form from any other forms on the page, I gave the form tag the id "searchform". Now that we've got the HTML done, we need to style the search form.

## The CSS

```css
#searchform, #searchform fieldset,
#searchform input, #searchforum button, .button {
     margin: 0; padding: 0; border: 0;/* restore sanity */
     }
#searchform {
     width: 160px;
     background: url(images/nav_images.png) -289px -4px;
     font-family: "Lucida Grande",
          "Lucida Sans", Arial, Verdana, sans-serif;
     }
     #searchform fieldset {
         padding: 8px 8px 0 8px;
         width: 100%;
         height: 30px;
         }
     #searchform #search {
         float: left;
         padding: 3px;
         width: 112px;
         height: 16px;
         border: 1px solid #efdfdb;
         border-right: 0;
         background: #fff;
         color: #ccc;
         }
             #searchform #search:focus {
                 color: #ab6661;
                 }
    #searchform button.button {
         float: left;
         width: 24px;
         height: 24px;
         background: #fff url(images/button.png) left top no-repeat;
         text-indent: -2000px;
         }
             #searchform .button:hover {
                 background-color: #f0ddd8;
                 }
```

It would take too long to explain the CSS in detail, but to summarise:

- I'm styling the `<form>` and `<fieldset>` tags, instead of utilising extra useless `<div>`'s in the markup
- The background image used is actually from a larger sprite that I made with multiple images in, this is to reduce server requests during page loads, but it required some fancy background positioning
- The `:hover` state of the `<button>` is achieved with a transparent png and a change in background-color on hover. I should note that in IE8 (haven't tested in versions prior but I'll assume it applies to IE7), the :hover effect for the `<button>` doesn't work unless a suitable DTD is specified

To further enhance the search form on moanlog we used javascript to automatically clear the box upon focus

```javascript
window.onload=function()
     {
     var B=document.getElementById("searchform");
     if(B)
         {
         B.search.onfocus=function()
             {
             if(B.search.value=="Search")
                 {
                 B.search.value=""
                 }
             };
         B.search.onblur=function()
             {
             if(B.search.value=="")
                 {
                 B.search.value="Search"
                 }
             }
         }
     }
```

This javascript searches for elements with the "searchform" id within the page, when it finds one it checks if the input box has focus - if it does it clears the "Search" text of the input box. Likewise, when the input box hasn't got focus and is empty it puts the "Search" text back into it.
