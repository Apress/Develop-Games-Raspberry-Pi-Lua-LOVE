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

Hero = { }

function Hero.init()
   local self = setmetatable({}, Hero)

   self.ani = {}
   for i=0,2,1 do
      self.ani[#self.ani+1] = love.graphics.newQuad((10+i)*t,3*t,t,t,sheet:getDimensions()) --right 123
      self.face = "e"
   end
   for i=0,2,1 do
      self.ani[#self.ani+1] = love.graphics.newQuad((10+i)*t,1*t,t,t,sheet:getDimensions()) --left 456
      self.face = "w"
   end
   for i=0,2,1 do
      self.ani[#self.ani+1] = love.graphics.newQuad((10+i)*t,2*t,t,t,sheet:getDimensions()) --down 789
      self.face = "s"
   end
   for i=0,2,1 do
      self.ani[#self.ani+1] = love.graphics.newQuad((10+i)*t,0*t,t,t,sheet:getDimensions()) --up 10-12
      self.face = "n"
   end

   self.img = self.ani[7]
   self.x   = t
   self.y   = t
   self.speed = t/2
   --self.hp  = math.random( 8,20 ) --health
   self.xp  = 10 --experience .. and health
   return self
end
