---
title: A Dialog System
tags: [pico-8]
archived: true
---
This is a flexible dialog system I've come up with.

It has the following features:

- automatically wrap long lines of text
- automatically page super long text to additional dialogs
- delay control
- per-letter display

First, here are some of the helper functions that I'm using...

```lua
-- draw a box with a frame
-- arguments:
--  x,y position
--  w,h dimensions
--  p padding
--  fg,bg foreground and background colors
function box(x,y,w,h,p,fg,bg)
  rectfill(x,y,x+w,y+h,bg)
  rect(x+p,y+p,x+w-p-1,y+h-p-1,fg)
end
```

```lua
-- joins two tables
function jt(table1,table2)
  local new = {}
  for k,v in pairs(table1) do new[k] = v end
  for k,v in pairs(table2) do new[k] = v end
  return new
end
```

```lua
-- sleep for a set number of seconds (using 30fps mode)
function sleep(s)
  for i=1,s*30 do flip() end
end
```

And lastly, the meat of the dialog system. I've scattered some comments through-out the code to try to explain what I'm doing. I'll provide some initialisation examples after...

```lua
function dialog(d)
  d = d or {}
  -- defaults
  _d = {
    a = true,
    bg = 5,
    c = false,
    dl = 5,
    fg = 7,
    p = 8,
    t = true,
    ts = 0.05,
    txt = "",
    w = 128,
    y = 96
  }
  -- slightly dynamic defaults
  _d.x = (128 / 2) - (_d.w / 2)
  _d.h = 128 - _d.y
  -- merge passed options with default
  _d = jt(_d, d)

  -- text
  _ch = 6 -- char height
  _wi = _d.w - (_d.p * 2)
  _wrap = (_wi / 4) - 1 -- 27

  local lines = {}
  local limit = ceil(#_d.txt / _wrap)
  local _tb = _d.txt
  while limit > 0 do
    local substr = sub(_tb, 1, _wrap) -- grab first bit
    -- ensure line doesn't have a space at the start
    if sub(substr,1,1) == " " then
      substr = sub(substr, 2)
    end
    add(lines, substr) -- stick it in our lines table
    _tb = sub(_tb, _wrap + 1, -1) -- get rest of text
    limit -= 1
  end

  -- lines limit
  _ll = flr((_d.h - _d.p - _ch) / _ch)
  if _d.t == true then
    -- type it out
    box(_d.x, _d.y, _d.w, _d.h, _d.p / 2, _d.fg, _d.bg)
    for l=1,_ll do
      local _l = lines[l] or ""
      -- vertical alignment
      local va = _d.y + _d.p + ((l - 1) * 6)
      local _lld = _ll
      while _lld > 1 do
        if #lines < _lld then
          va += (_ch / 2)
        end
        _lld -= 1
      end
      -- center it if necessary
      local ha = _d.x + _d.p
      if _d.c == true then
        ha = _d.x + (_d.w / 2) - (#_l * 2)
      end
      local chars = {}
      local limit = #_l
      local ci = 0
      -- split line in to chars
      while limit > 0 do
        local _ch = sub(_l, 1, ci + 1)
        add(chars, _ch)
        ci += 1
        limit -= 1
      end
      for c=1,#chars do
        print(chars[c], ha, va, _d.fg)
        if _d.a == true then sfx(0) end
        sleep(_d.ts) -- tiny delay
      end
    end
  else
    -- print normally
    box(_d.x, _d.y, _d.w, _d.h, _d.p / 2, _d.fg, _d.bg)
    for l=1,_ll do
      local _l = lines[l] or ""
      -- vertical alignment
      local va = _d.y + _d.p + ((l - 1) * 6)
      local _lld = _ll
      while _lld > 1 do
        if #lines < _lld then
          va += (_ch / 2)
        end
        _lld -= 1
      end
      -- center it if necessary
      local ha = _d.x + _d.p
      if _d.c == true then
        ha = _d.x + (_d.w / 2) - (#_l * 2)
      end
      print(_l, ha, va, _d.fg)
      if _d.a == true then sfx(0) end
    end
  end

  if #lines > _ll  then
    local _nl = lines
    -- delete strings we've used
    for i=1,_ll do
      del(_nl,lines[1])
    end
    -- join thr remaining
    local str = ""
    if #_nl > 1 then
      for i=1,#_nl do
        str = str .. _nl[i]
      end
    else
      str = _nl[1]
    end
    sleep(_d.dl) -- delay before next
    -- call recursive
    local n = jt(_d, {txt=str})
    dialog(n)
  else
    sleep(_d.dl) -- delay before next
  end
end
```

Whew that was a lot of code. Here's how you can use it:

```lua
-- short, centered, delay of 2
dialog({
 txt = "hello,",
 c = true,
 dl = 2
})
-- short, centered
dialog({
 txt = "my name is inigo montoya",
 c = true
})

-- short, centered
dialog({
 txt = "you killed my father",
 c = true
})

-- short, centered, not typed
dialog({
 txt = "prepare to die!",
 c = true,
 t= false
})

-- long, typed, multiple message boxes
dialog({txt="this is a lot of text that will wrap on to multiple lines and hopefully use a recursive message box in order to show all of the text ♥"})

```

You can see how this all looks below:

{% include posts/figure.html src="pico-8/dialog.gif" %}{:.center}
