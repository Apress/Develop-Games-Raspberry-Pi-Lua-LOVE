-- Battlejack (in progress)
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

menu = {}

local entries = { "New game", "Load saved",
      "Window mode", "Save", "Quit" }

local menmax = 5

function menu.activate()
    STATE = menu
    selection = 1
    font = love.graphics.setNewFont("font/Junction_regular.otf",14)
end

function menu.draw()
    love.graphics.setBackgroundColor(0.1,0.1,0.1)
    -- love.graphics.push()
    for i=1,5 do
	if i == selection then
            love.graphics.print(">", 30, 10+i*16)
	end
	-- menu text
	love.graphics.print(entries[i], 45, 10+i*16)
    end
    -- love.graphics.pop()
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
	    window.activate()
	elseif selection == 4 then
            save()
	elseif selection == 5 then
	    love.event.quit()
	end
    elseif k == "escape" then
    	game.activate()
    end
end
