---
title: Using jQuery to supply and clear default input values
tags: [jquery, javascript, tutorial]
archived: true
archive: omgmog.net
---

This is a repost of a solution I provided over at the smashing magazine forums. I'm posting it here as it's a pretty useful solution in itself.

The original question is as follows:

> I'm building a new website and on this one page I need to use a huge form, instead of using labels I want to enter the "label" text in the value attribute and then use JS to clear the field on mouseclick.
>
> The problem is that every field needs to be filled out. I don't want users hitting the submit button with some of the standard values still in place (easy to miss certain stuff) because this will mess things up.
>
> I can ofcourse check for empty fields but to do this I need to somehow check if all the fields have been changed on form submit.

So I whipped up a quick implementation of how I would do it using jQuery.

<!-- more -->

HTML:

```html
<form id="someForm">
<label class="someLabel" for="name">Name</label>
<input class="someInput" name="name" id="name" value="" />
<label class="someLabel" for="email">Email</label>
<input class="someInput" name="email" id="email" value="" />
<label class="someLabel" for="website">Website</label>
<input class="someInput" name="website" id="website" value="" />
<button type="submit">Submit</button>
</form>
```

A bit of CSS styling:

```css
#someForm {
display: block;
text-align: left;
padding: 20px;
margin: 0 auto;
width: 400px;
}
.someLabel {
clear: both;
display: block;
}
.someInput {
clear: both;
display: block;
margin-bottom: 10px;
}
button {
clear: both;
}
```

jQuery:

```javascript
$(function(){
var inputs = $(".someInput");
var labels = $(".someLabel");
$.each( inputs, function(){
var index = inputs.index(this);
if($(this).val()==""){
$(this).attr("value",labels.eq(index).text());
}
$(this).focus(function(){
if($(this).val()==labels.eq(index).text()){
$(this).attr("value","");
}
});
$(this).blur(function(){
if($(this).val()==""){
$(this).attr("value",labels.eq(index).text());
}
});
});
});
```

If you don't want to assign classes to each of the form inputs and labels, you could select them based on something like `$("#formId input")`, and `$("#formId label")` instead.

Additionally, if you wanted to hide the label elements too, you could add the following line after the first variable declarations:

```javascript
labels.each(function(){$(this).hide();});
```
