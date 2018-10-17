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

Room = { }

function Room.init(w,h)
   local self = setmetatable({}, Room)

   -- room dimensions
   self.w = math.random( 4,24 );
   self.h = math.random( 4,14 );

   -- how much treasure
   -- how many monsters
   -- how many traps
   if self.w < 7 or self.h < 7 then
      self.treasure = math.random(0,1)
      self.monster = math.random(0,1)
      self.trap = math.random(0,1)
   else
      self.treasure = math.random(0,2)
      self.monster = math.random(0,2)
      self.trap = math.random(0,2)
   end

   -- number of doors
   self.north = bool(math.random(1,20)%2) --row
   self.east = bool(math.random(1,20)%2) --col
   self.south = bool(math.random(1,20)%2) --row
   self.west = bool(math.random(1,20)%2) --col

   -- if a door is marked hot then
   -- there must be a door in the next room
   if string.sub(hot['name'], 1, 1) == 'n' then
      self.south = true
      self.north = true
   elseif string.sub(hot['name'], 1, 1) == 's' then
      self.north = true
      self.south = true
   elseif string.sub(hot['name'], 1, 1) == 'e' then
      self.east = true
      self.west = true
   else
      self.east = true
      self.west = true
   end 

   self.phlogiston = floor[4]
   return self
end

function bool(value)
   return ( value == 1 and true or false )
end
