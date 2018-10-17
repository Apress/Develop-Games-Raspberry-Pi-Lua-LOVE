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

Trap = { }

function Trap.init(w,h)
   local self = setmetatable({}, Trap)

   self.x = math.random(t*2,(w*t)-(t*2))
   self.y = math.random(t*2,(h*t)-(t*2))

   self.state = {}

   self.state[1] = love.graphics.newQuad(6*t,15*t,t,t,sheet:getDimensions()) --crack
   self.state[3] = love.graphics.newQuad(11*t,14*t,t,t,sheet:getDimensions()) --pit
   self.state[2] = love.graphics.newQuad(6*t,13*t,t,t,sheet:getDimensions()) --spike trap
   self.state[4] = love.graphics.newQuad(8*t,13*t,t,t,sheet:getDimensions()) --spikesprung

   self.sel = math.random(1,2)
   self.img  = self.state[self.sel]
   self.live = true
   
   -- damage
   if self.sel == 1 then
      self.dmg = math.random(1,3)
   else
      self.dmg = math.random(3,6)
   end
   
   return self
end
