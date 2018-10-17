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

Card = { }

function Card.init(c,v,f,x,y)
   -- generate card
   local self = setmetatable({}, Card)
   self.color = c
   self.value = v
   self.face  = f
   self.x = x
   self.y = y
   self.mv= 0
   self.r = 0
   self.bonus = 0
   
   if self.face == "back" or self.face == "joker" then
      self.img = love.graphics.newImage("img" .. d .. self.face .. ".png")
   else
      self.img = love.graphics.newImage("img" .. d .. self.color .. d .. self.value .. "-" .. self.face .. ".png")
   end
   
   self.wide = self.img:getWidth()*scale
   self.high = self.img:getHeight()*scale

   return self
end
