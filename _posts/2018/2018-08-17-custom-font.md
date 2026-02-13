---
title: A custom font
tags: [pico-8]
archived: true
---

Out of the box Pico-8 has one font. It's the utilitarian answer to most problems. 3px by 5px and fairly legible.

{% include posts/figure.html src="pico-8/font-default.png" %}{:.center}

This font isn't always good enough. How about making your own font?

I've seen lots of approaches for creating fonts in Pico-8 -- mostly using sprites for each glyph of the font, but then you're limited to 8x8px and a have to mess with `pal` modes if you want to adjust colors on-the-fly.

My approach uses the raw pixel data encoded in strings that are rendered using calls to `pset`, falling back to the built-in font for any missing glyphs.

{% include posts/figure.html src="pico-8/font-all.png" %}{:.center}

First, here are my helper functions...

```lua
-- merge tables
function mt(t1,t2)
 local new = {}
 for k,v in pairs(t1) do new[k] = v end
 for k,v in pairs(t2) do new[k] = v end
 return new
end
```

```lua
-- less verbose way to do ternary operations
function ternary(cond ,t ,f )
 if cond then return t else return f end
end
```

I had to come up with a compact way to represent the glyphs. Initially I used something like:

```lua
{ glyph = "o", pixels = {
    0,1,1,1,0,
    1,0,0,0,1,
    1,0,0,0,1,
    1,0,0,0,1,
    1,0,0,0,1,
    1,0,0,0,1,
    0,1,1,1,0,
}}
```

But that contains a lot of _tokens_ and lots of repeated/dead values to represent the empty pixels in a glyph.

Eventually I moved to something like:

```lua
{"o",  "0.1.3.1.1.3.2.3.2.3.2.3.2.3.1.1.3"}
```
That's the same pixel data, but encoded in to a much shorter string.

The first number indicates our starting parity -- this can be 0 or 1 and tells us if the top/left pixel is empty or filled.

Each time we have a `.` the parity flips, so with the example of our "o" glyph it starts with `0` for 1 count, then `1` for 3 counts, `0` for 1 count, `1` for 1 count, etc.

When the remaining pixels in a glyph are `0` we can just omit them from the glyph data as they're not drawn.

The real wins are in the more simple/empty glyphs, such as "." for example.

Before:

```lua
{ glyph = ".", pixels = {
    0,0,0,0,0,
    0,0,0,0,0,
    0,0,0,0,0,
    0,0,0,0,0,
    0,0,0,0,0,
    0,0,0,0,0,
    0,0,1,0,0,
}}
```

After:

```lua
{".", "0.32.1"}
```

Making this change took me from an initial token count of roughly 2800 to a much more manageable count of 560-ish.

So with that technical talk out of the way, here's the complete glyph set in code, and the function to render text. I'll give some usage examples after.

```lua
global_y = 0

function write(str,opts)
 opts = opts or {}
 _opts = {
  x=0,
  y=global_y,
  c=7
 }
 opts = mt(_opts,opts)
 font = {
  w=5,
  h=7,
  -- first num indicates starting value, 0 or 1
  -- each number indicates number of 0 or 1 in a row
  -- flips at each .
  glyphs = {
   {"0",  "0.1.3.1.1.3.2.3.2.3.2.3.2.3.1.1.3"},
   {"1",  "0.2.1.3.2.2.1.1.1.4.1.4.1.4.1.2.5"},
   {"2",  "0.1.3.1.1.3.1.4.1.3.1.3.1.3.1.3.5"},
   {"3",  "0.1.3.1.1.3.1.4.1.2.2.5.2.3.1.1.3"},
   {"4",  "0.3.2.2.1.1.1.1.1.2.2.3.6.4.1.4.1"},
   {"5",  "1.6.4.1.5.3.5.2.3.1.1.3"},
   {"6",  "0.1.3.1.1.3.2.4.4.1.1.3.2.3.1.1.3"},
   {"7",  "1.5.4.1.4.1.3.1.3.1.3.1.3.1"},
   {"8",  "0.1.3.1.1.3.2.3.1.1.3.1.1.3.2.3.1.1.3"},
   {"9",  "0.1.3.1.1.3.2.3.1.1.4.4.2.3.1.1.3"},
   {"a",  "0.1.3.1.1.3.2.3.7.3.2.3.2.3.1"},
   {"b",  "1.4.1.1.3.2.3.5.1.1.3.2.3.5"},
   {"c",  "0.1.3.1.1.3.2.4.1.4.1.4.1.3.1.1.3.1"},
   {"d",  "1.4.1.1.3.2.3.2.3.2.3.2.3.5"},
   {"e",  "1.6.4.1.4.4.1.1.4.1.4.5"},
   {"f",  "1.6.4.1.4.4.1.1.4.1.4.1"},
   {"g",  "0.1.3.1.1.3.2.3.2.4.1.1.4.3.1.1.3"},
   {"h",  "1.1.3.2.3.2.3.7.3.2.3.2.3.1"},
   {"i",  "1.5.2.1.4.1.4.1.4.1.4.1.2.5"},
   {"j",  "1.5.2.1.4.1.4.1.2.1.1.1.2.1.1.1.3.2"},
   {"k",  "1.1.3.2.2.1.1.1.1.1.2.2.3.1.1.1.2.1.2.1.1.1.3.1"},
   {"l",  "1.1.4.1.4.1.4.1.4.1.4.1.4.5"},
   {"m",  "1.1.3.3.1.3.1.1.1.2.3.2.3.2.3.2.3.1"},
   {"n",  "1.1.3.3.2.2.1.1.1.2.2.3.3.2.3.2.3.1"},
   {"o",  "0.1.3.1.1.3.2.3.2.3.2.3.2.3.1.1.3"},
   {"p",  "1.4.1.1.3.2.3.5.1.1.4.1.4.1"},
   {"q",  "0.1.3.1.1.3.2.3.2.3.2.3.1.1.3.5.1"},
   {"r",  "1.4.1.1.3.2.3.5.1.1.1.1.2.1.2.1.1.1.3.1"},
   {"s",  "0.1.3.1.1.3.2.5.3.5.2.3.1.1.3"},
   {"t",  "1.5.2.1.4.1.4.1.4.1.4.1.4.1"},
   {"u",  "1.1.3.2.3.2.3.2.3.2.3.2.3.1.1.3"},
   {"v",  "1.1.3.2.3.1.1.1.1.1.2.1.1.1.2.1.1.1.3.1.4.1"},
   {"w",  "1.1.3.2.3.2.3.2.1.1.1.2.1.1.1.2.1.1.1.1.1.1.1.1"},
   {"x",  "1.1.3.2.3.1.1.1.1.1.3.1.3.1.1.1.1.1.3.2.3.1"},
   {"y",  "1.1.3.1.1.1.1.1.3.1.4.1.4.1.4.1.4.1"},
   {"z",  "1.5.4.1.3.1.3.1.3.1.3.1.4.5"},
   {" ",  "0.35"},
   {".",  "0.32.1"},
   {",",  "0.27.1.3.1"},
   {"!",  "0.2.1.4.1.4.1.4.1.4.1.9.1"},
   {"?",  "0.1.3.1.1.3.1.4.1.3.1.3.1.9.1"},
   {"'",  "0.3.1.3.1"},
   {"\"", "0.1.1.1.1.1.1.1.1"},
   {":",  "0.12.1.14.1"},
   {";",  "0.12.1.14.1.3.1"},
   {"(",  "0.3.1.3.1.3.1.4.1.4.1.5.1.5.1"},
   {")",  "0.1.1.5.1.5.1.4.1.4.1.3.1.3.1"},
   {"[",  "0.1.3.2.1.4.1.4.1.4.1.4.1.4.3"},
   {"]",  "0.1.3.4.1.4.1.4.1.4.1.4.1.2.3"},
   {"{",  "0.2.2.3.1.4.1.3.2.4.1.4.1.4.2"},
   {"}",  "0.1.2.4.1.4.1.4.2.3.1.4.1.3.2"},
   {"<",  "0.3.1.3.1.3.1.3.1.5.1.5.1.5.1"},
   {">",  "0.1.1.5.1.5.1.5.1.3.1.3.1.3.1"},
   {"-",  "0.16.3"},
   {"+",  "0.12.1.3.3.3.1"},
   {"/",  "0.4.1.3.1.4.1.3.1.3.1.4.1.3.1"},
   {"\\", "1.1.5.1.4.1.5.1.5.1.4.1.5.1"},
  }
 }

 _x = opts.x
 _y = opts.y
 letters = {}
 for i=1,#str do
  letter = sub(str,i,i)
  add(letters,letter)
 end
 for k,v in pairs(letters) do
  letter = nil
  for _glyph in all(font.glyphs) do
   if _glyph[1] == v then
    letter = _glyph[2]
   end
  end
  local _sx = _x
  local _sy = _y
  if letter != nil then
   local _px = _sx
   local _py = _sy
   pixels = {}
   local _p = sub(letter,1,1)
   local prev = nil
   for i=2,#letter do
    cur = sub(letter,i,i)
    if type(prev) == "number" and cur != "." then
     cur = sub(letter, i-1, i)
    end
    if cur == "." then
     _p = ternary(_p == "0", "1", "0")
    else
     for j=1,tonum(cur) do
      add(pixels, _p)
     end
    end
    prev = tonum(cur)
   end
   for i,p in pairs(pixels) do
    i = i - 1
    if i % font.w == 0 then
     _py += 1
     _sx = _x - (font.w * (i / font.w))
    end
    _px = _sx + i
    if p == "0" then
     pset(_px, _py, opts.c)
    end
   end
  else
   font.w = 8
   print(v, _sx, _y + ((font.h - 2)/2), opts.c)
  end
  _x += font.w + 1
 end
 global_y += font.h + 2
end
```

If you're still with me, congratulations! Here is how you use the function:

```lua
function _draw()
 cls()
 global_y = 0 -- reset on each draw call
 write("hello world")

 -- passing a color is possible!
 write("this is max 🐱", {c=12})

 write("my font brings all")
 write("the devs to the yard")
 write("0123456789")
 write("abcdefghijklm")
 write("nopqrstuvwxyz")
 write(".,?!:;()[]{}-+/\\<>")
 write("yes, this is a lot")
 write("nicer to read! ♥")
 write("")
 write("█▒🐱⬇️░✽●♥☉웃⌂⬅️😐")
 write("♪🅾️◆…➡️★⧗⬆️ˇ∧❎▤▥")
 write("@#$%^&*")
end
```

And this is how it looks:

{% include posts/figure.html src="pico-8/font-preview.png" %}{:.center}
