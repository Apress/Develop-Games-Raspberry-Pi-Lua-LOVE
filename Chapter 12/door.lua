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

Door = { }

function Door.init(face,w,h)
   local self = setmetatable({}, Door)

   self.face = face

   if self.face == "n" then
      --      self.x = (w*t)/2
      self.x = (math.random(t,w*t)-t)
      self.y = t
   elseif self.face == "e" then
      self.x = (w*t+(t/2))-t
      --self.y = (h*t)/2
      self.y = (math.random(t,h*t)-t)
   elseif self.face == "s" then
      --self.x = (w*t)/2
      self.x = (math.random(t,w*t)-t)
      self.y = (h*t)-t
   else
      self.x = (0+(t/2))+t
      --self.y = (h*t)/2
      self.y = (math.random(t,h*t)-t)
   end

   self.go = true
   return self
end
