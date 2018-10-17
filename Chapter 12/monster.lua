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

Monster = { }

function Monster.init(w,h)
   local self = setmetatable({}, Monster)
   self.x = math.random(t*3,(w*t)-(t*2))
   self.y = math.random(t*3,(h*t)-(t*2))

   self.face = {}
   self.dmg = 1

   -- armour strength
   if math.random(1,20)%2 == 0 then -- fungus
      self.ac = math.random(5,10)
      self.name = "fungus"
      self.face[1] = love.graphics.newQuad(0*t,0*t,t,t,sheet:getDimensions()) --fungus up
      self.face[2] = love.graphics.newQuad(1*t,0*t,t,t,sheet:getDimensions()) --fungus up
      self.face[3] = love.graphics.newQuad(2*t,0*t,t,t,sheet:getDimensions()) --fungus up
      self.face[4] = love.graphics.newQuad(0*t,2*t,t,t,sheet:getDimensions()) --fungus down
      self.face[5] = love.graphics.newQuad(1*t,2*t,t,t,sheet:getDimensions()) --fungus down
      self.face[6] = love.graphics.newQuad(2*t,2*t,t,t,sheet:getDimensions()) --fungus down
   else
      self.ac = math.random(10,20)
      self.name = "golem"
      self.face[1] = love.graphics.newQuad(9*t,5*t,t,t,sheet:getDimensions()) 
      self.face[2] = love.graphics.newQuad(10*t,5*t,t,t,sheet:getDimensions())
      self.face[3] = love.graphics.newQuad(11*t,5*t,t,t,sheet:getDimensions())
      self.face[4] = love.graphics.newQuad(9*t,7*t,t,t,sheet:getDimensions()) 
      self.face[5] = love.graphics.newQuad(10*t,7*t,t,t,sheet:getDimensions())
      self.face[6] = love.graphics.newQuad(11*t,7*t,t,t,sheet:getDimensions())
   end

   -- damage
   if self.face == "fungus" then --fungus
      self.dmg = math.random(6,18)
   else --golem
      self.dmg = math.random(8,24)
   end

   -- xp value for battle
   self.xp = self.ac*3

   self.go = 1 --or 4
   self.img = self.face[1]
   self.battle = false --is it engaged in battle
   self.alive = true

   return self
end
