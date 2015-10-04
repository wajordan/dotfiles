local application = require "hs.application"
local fnutils = require "hs.fnutils"
local grid = require "hs.grid"
local hotkey = require "hs.hotkey"
local mjomatic = require "hs.mjomatic"
local window = require "hs.window"

grid.MARGINX = 0
grid.MARGINY = 0
grid.GRIDHEIGHT = 13
grid.GRIDWIDTH = 13

local mash = {"cmd", "alt", "ctrl"}
local mashshift = {"cmd", "alt", "ctrl", "shift"}


--
-- toggle push window to edge and restore to screen
--

-- somewhere to store the original position of moved windows
local origWindowPos = {}

-- cleanup the original position when window restored or closed
local function cleanupWindowPos(_,_,_,id)
  origWindowPos[id] = nil
end

-- function to move a window to edge or back
local function movewin(direction, fill)
  fill = fill or 'none'
  local win = hs.window.focusedWindow()
  local res = hs.screen.mainScreen():frame()
  local id = win:id()

  if not origWindowPos[id] then
    -- move the window to edge if no original position is stored in
    -- origWindowPos for this window id
    local f = win:frame()
    origWindowPos[id] = win:frame()

    -- add a watcher so we can clean the origWindowPos if window is closed
    local watcher = win:newWatcher(cleanupWindowPos, id)
    watcher:start({hs.uielement.watcher.elementDestroyed})

    if fill == 'half' then
       if direction == "left" then
          f.x = res.x
          f.y = res.y
          f.w = res.w / 2
          f.h = res.h
       end
       if direction == "right" then
          f.x = res.w / 2
          f.y = res.y
          f.w = res.x
          f.h = res.h
       end
       if direction == "up" then
          f.x = res.x
          f.y = res.y
          f.w = res.w
          f.h = res.h / 2
       end
       if direction == "down" then
          f.x = res.x
          f.y = res.h / 2
          f.w = res.w
          f.h = res.y
       end
    else
       if direction == "left" then f.x = (res.w - (res.w * 2)) + 10 end
       if direction == "right" then f.x = (res.w + res.w) - 10 end
       if direction == "down" then f.y = (res.h + res.h) - 10 end
    end
    win:setFrame(f)
  else
    -- restore the window if there is a value for origWindowPos
    win:setFrame(origWindowPos[id])
    -- and clear the origWindowPos value
    cleanupWindowPos(_,_,_,id)
  end
end

hs.hotkey.bind(mash, "A", function() movewin("left") end)
hs.hotkey.bind(mash, "D", function() movewin("right") end)
hs.hotkey.bind(mash, "S", function() movewin("down") end)
--
-- /toggle push window to edge and restore to screen
--

--
-- Open Applications
--
local function openchrome()
  application.launchOrFocus("Google Chrome")
end

--local function openff()
  --application.launchOrFocus("FirefoxDeveloperEdition")
--end

--local function openmail()
  --application.launchOrFocus("Airmail Beta")
--end

--hotkey.bind(mash, 'F', openff)
hotkey.bind(mash, 'C', openchrome)
--hotkey.bind(mash, 'M', openmail)
--
-- /Open Applications
--


--
-- Window management
--
--Alter gridsize
hotkey.bind(mashshift, '=', function() grid.adjustHeight( 1) end)
hotkey.bind(mashshift, '-', function() grid.adjustHeight(-1) end)
hotkey.bind(mash, '=', function() grid.adjustWidth( 1) end)
hotkey.bind(mash, '-', function() grid.adjustWidth(-1) end)

--Snap windows
hotkey.bind(mash, ';', function() grid.snap(window.focusedWindow()) end)
hotkey.bind(mash, "'", function() fnutils.map(window.visibleWindows(), grid.snap) end)

-- hotkey.bind(mashshift, 'H', function() window.focusedWindow():focusWindowWest() end)
-- hotkey.bind(mashshift, 'L', function() window.focusedWindow():focusWindowEast() end)
-- hotkey.bind(mashshift, 'K', function() window.focusedWindow():focusWindowNorth() end)
-- hotkey.bind(mashshift, 'J', function() window.focusedWindow():focusWindowSouth() end)

--Move windows
hotkey.bind(mash, 'DOWN', grid.pushWindowDown)
hotkey.bind(mash, 'UP', grid.pushWindowUp)
hotkey.bind(mash, 'LEFT', grid.pushWindowLeft)
hotkey.bind(mash, 'RIGHT', grid.pushWindowRight)

hs.hotkey.bind(mash, "H", function() movewin("left", "half") end)
hs.hotkey.bind(mash, "L", function() movewin("right", "half") end)
hs.hotkey.bind(mash, "J", function() movewin("up", "half") end)
hs.hotkey.bind(mash, "K", function() movewin("down", "half") end)

--resize windows
hotkey.bind(mashshift, 'UP', grid.resizeWindowShorter)
hotkey.bind(mashshift, 'DOWN', grid.resizeWindowTaller)
hotkey.bind(mashshift, 'RIGHT', grid.resizeWindowWider)
hotkey.bind(mashshift, 'LEFT', grid.resizeWindowThinner)

hotkey.bind(mash, 'N', grid.pushWindowNextScreen)
hotkey.bind(mash, 'P', grid.pushWindowPrevScreen)

hotkey.bind(mash, 'M', grid.maximizeWindow)



--
-- /Window management
--


--
-- Monitor and reload config when required
--
function reload_config(files)
  caffeine:delete()
  hs.reload()
end
hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reload_config):start()
hs.alert.show("Config loaded")
--
-- /Monitor and reload config when required
--
