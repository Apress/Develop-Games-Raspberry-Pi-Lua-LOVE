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

msg = {}

function msg.activate()
   STATE = msg
   font = love.graphics.setNewFont("font/Junction_regular.otf",24)
   button_ok = love.graphics.newImage("img" .. d .. "button_ok.png")
end

function msg.draw()
   love.graphics.setBackgroundColor(0.1,0.1,0.1)
   if earncard ~= nil then
      love.graphics.draw(upcard.img,((WIDE-upcard.wide)/2)-upcard.wide,pad,0,scale,scale,0,0)
      love.graphics.draw(earncard.img,(WIDE+earncard.wide)/2,pad,0,scale,scale,0,0)
   else -- only one card to display
      love.graphics.draw(upcard.img,((WIDE-upcard.wide)/2),pad,0,scale,scale,0,0)
   end
   love.graphics.printf(message,0,pad+HIGH/3,WIDE,'center')

   love.graphics.draw(button_ok, (WIDE/2)-(button_ok:getWidth()/2),HIGH/2,0,1,1,0,0)
end

function msg.keypressed(k)
   game.activate()
end

function msg.clicker(x,y,tgt)
   return (
      x < (WIDE/2)-(button_ok:getWidth()/2) + tgt:getWidth() and
        x > (WIDE/2)-(button_ok:getWidth()/2) and
	 y < HIGH/2 + tgt:getHeight() and
        y > HIGH/2
    )
    -- returns True or False
end

function msg.mousepressed(x,y,btn)
   if btn == 1 and msg.clicker(x,y,button_ok) then
      game.activate()
   end
end

function msg.mousereleased(x,y,btn)
   return false
end
