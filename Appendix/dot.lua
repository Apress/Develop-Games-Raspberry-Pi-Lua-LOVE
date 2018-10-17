--[[ GNU All-Permissive License

Copying and distribution of this file, with or without modification,
are permitted in any medium without royalty provided the copyright
notice and this notice are preserved.  This file is offered as-is,
without any warranty.

https://www.gnu.org/licenses/license-list.en.html ]]--

Dot = { }

function Dot.init(x,y)
   local self = setmetatable({}, Dot)
   self.img = love.graphics.newImage("img.png")
   self.x = x
   self.y = y
   self.moving = 0
   self.r = 0
   return self
end
