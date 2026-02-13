---
title: Approaches for a simple state system
tags: [pico-8]
archived: true
---

There are lots of ways to achieve even the most simple goal in programming, and Pico-8 -- even with it's limited nature -- is no different to any other system.

Today I'm looking at state systems. There are lots of approaches to handling state out there, and each has their own pros and cons. In Pico-8 the main concern is keeping the token count low so that you can add more features to your game.


## Beginner state system

This first state system uses a `state` variable and an _enum_ table of available states to decide which state we're currently in. The `state` variable is updated by user input (button press, or death) and it's contents controls which functions are executed in the `_update()` and `_draw()` functions.

If you've got a huge game the conditions in the `_update()` and `_draw()` functions can quickly become unweildly.

The main benefit here is that you can control what to execute in the `_update()` and `_draw()` functions from one place.

This approach is quite token hungry.

```lua
function _init()
  t = 0 -- create timer
  state = 1
  states = {
    menu = 1,
    game = 2,
    gameover = 3
  }
  hp = 100
end
function _update()
  t += 1 -- increment timer
  if state == states.menu then
    update_menu()
  elseif state == states.game then
    update_game()
  else
    update_gameover()
  end
end
function _draw()
  if state == states.menu then
    draw_menu()
  elseif state == states.game then
    draw_game()
  else
    draw_gameover()
  end
end

function update_menu()
  if btn(4) and btn(5) then
    state = states.game
  end
end
function draw_menu()
  print("Press z and x to start")
end

function update_game()
  if hp < 1 then
    state = states.gameover
  end
end
function draw_game()
  print("HP: "..hp)
end

function update_gameover()
  if btn(4) and btn(5) then
    state = states.game
  end
end
function draw_gameover()
  print("Press z and x to start over")
end

```

## Improved state system

This is the approach I prefer, the `_update()` and `_draw()` functions call a variable that points to another function. To change state you simply update this variable.

There is no variable or enum needed to keep track of state, but you do need to explicitly redeclare the `_upd` and `_drw` variables each time you change state.

This is approach is quite light on the token count.

```lua
-- core init/update/draw functions
function _init()
  t = 0 -- create timer
  hp = 100
  _upd = upd_menu
  _drw = drw_menu
end
function _update()
  t += 1 -- increment timer
  _upd()
end
function _draw()
  cls()
  _drw()
end

-- menu update/draw functions
function upd_menu()
  if btn(4) and btn(5) then
    _upd = upd_game
    _drw = drw_game
  end
end
function drw_menu()
  print("Press z and x to start")
end

-- game update/draw functions
function upd_game()
  if hp < 1 then
    _upd = upd_gameover
    _drw = drw_gameover
  end
end
function drw_game()
  print("HP: "..hp)
end

-- gameover update/draw functions
function upd_gameover()
  if btn(4) and btn(5) then
    _upd = upd_game
    _drw = drw_game
  end
end
function drw_gameover()
  print("Press z and x to start over")
end
```
