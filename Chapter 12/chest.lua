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

Chest = { }

function Chest.init(w,h)
   local self = setmetatable({}, Chest)

   self.x = math.random(t*2,(w*t)-(t*2))
   self.y = math.random(t*2,(h*t)-(t*2))
   self.xp = math.random(10,100)
   self.full = true

   --treasure images
   self.state = {}
   --closed by default
   self.state[1] = love.graphics.newQuad(6*t,2*t,t,t,sheet:getDimensions())
   --opened
   self.state[2] = love.graphics.newQuad(8*t,2*t,t,t,sheet:getDimensions())

   self.img = self.state[1]
   return self
end
