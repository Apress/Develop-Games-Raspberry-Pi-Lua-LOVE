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

Bolt = { }

function Bolt.init(x,y)
   local self = setmetatable({}, Bolt)
   self.ani = {}

   self.ani[1] = love.graphics.newQuad(0*t,0*t,t,t,skull:getDimensions())
   self.ani[2] = love.graphics.newQuad(0*t,1*t,t,t,skull:getDimensions())
   self.ani[3] = love.graphics.newQuad(0*t,2*t,t,t,skull:getDimensions())
   self.ani[4] = love.graphics.newQuad(0*t,3*t,t,t,skull:getDimensions())
   self.img = self.ani[1]
   self.x = x
   self.y = y
   -- direction of fire
   self.face = hero.face
   self.speed = t/2 -- pixels per step
   return self
end
