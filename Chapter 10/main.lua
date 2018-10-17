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

package.path = package.path .. ';local/share/lua/5.1/?.lua' .. ';local/share/lua/5.3/?.lua'

require("menu")
require("game")
WIDE,HIGH = 960,720
STATE = nil

function love.load()
   love.window.setTitle(' Battlejack ')
   love.window.setMode( WIDE, HIGH )
   menu.activate()
end

function love.draw()
    --	love.graphics.push()
    STATE.draw()
    --	love.graphics.pop()
end

function love.keypressed(k)
    STATE.keypressed(k)
end

function love.mousepressed(x,y,button)
    STATE.mousepressed(x,y,button)
end

function love.mousereleased(x,y,button)
    STATE.mousereleased(x,y,button)
end

function love.quit()
    --	saveConfig()
    foo=1
end
