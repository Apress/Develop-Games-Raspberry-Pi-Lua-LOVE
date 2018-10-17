-- PERMADUNGEON
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

Floor = { }

function Floor.init()
   local self = setmetatable({}, Floor)

-- set floor type
   self[1] = love.graphics.newQuad(3*t,10*t,t,t,sheet:getDimensions())
   -- set wall type
   self[2] = love.graphics.newQuad(15*t,10*t,t,t,sheet:getDimensions())
   -- door type 
   self[3] = love.graphics.newQuad(10*t,14*t,t,t,sheet:getDimensions())
   -- forbidden zone
   self[4] = love.graphics.newQuad(13*t,6*t,t,t,sheet:getDimensions()) -- space
   self[5] = love.graphics.newQuad(3*t,9*t,t,t,sheet:getDimensions())  -- lava
   -- passageway
   self[6] = love.graphics.newQuad(0*t,14*t,t,t,sheet:getDimensions())
   return self
end
