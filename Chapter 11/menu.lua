-- Battlejack
-- by Seth Kenlon

--[[ This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program.  If not, see <https://www.gnu.org/licenses/>.
]]--

require("saver")

menu = {}

local entries = { "New game", "Load saved",
      "Window mode", "Save", "Return to game", "Quit" }

local menmax = #entries

function menu.activate()
   STATE = menu
   WIDE,HIGH = love.window.getMode()
   selection = 1
   font = love.graphics.setNewFont("font/Junction_regular.otf",14)
end

function menu.draw()
   love.graphics.setBackgroundColor(0.1,0.1,0.1)
   for i=1,menmax do
      if i == selection then
	 love.graphics.print(">", 30, 10+i*16)
      end
      -- menu text
      love.graphics.print(entries[i], 45, 10+i*16)
   end
end

function wrap(sel)
   if sel > menmax then
      sel = 1
   end
    
   if sel < 1 then
      sel = menmax
   end

   return sel
end

function menu.mousereleased(x,y,btn)
   return false
end

function menu.mousepressed(x,y,btn)
   return false
end

function menu.keypressed(k)
    if k == "down" then
	selection = wrap(selection+1)
    elseif k == "up" then
 	selection = wrap(selection-1)
    elseif k == "return" or k == " " then
	if selection == 1 then
            game.new()
	elseif selection == 2 then
	   game.load()
        elseif selection == 3 then
	   if not love.window.getFullscreen() then
	      love.window.setFullscreen(true, "desktop")
	      WIDE,HIGH = love.window.getMode()
	   else
	      WIDE,HIGH = 960,720
	      love.window.setMode(WIDE,HIGH)
	   end
	   love.window.updateMode(WIDE,HIGH,{resizable=true,vsync=false,minwidth=WIDE,minheight=HIGH})
	   fsupdated = 1
	elseif selection == 4 then
	   saver.gamedata()
	   saver.userdata()
	elseif selection == 5 then
	    game.activate()
	elseif selection == 6 then
	    love.event.quit()
	end
    elseif k == "escape" then
    	game.activate()
    end
end
