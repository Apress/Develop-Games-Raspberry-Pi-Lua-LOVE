--[[ GNU All-Permissive License

Copying and distribution of this file, with or without modification,
are permitted in any medium without royalty provided the copyright
notice and this notice are preserved.  This file is offered as-is,
without any warranty.

https://www.gnu.org/licenses/license-list.en.html ]]--

require("dot")

hot = {}

function love.load()
   Dot = Dot.init(300,300)
   hot[#hot+1] = Dot
end

function love.update(dt)
   for i,obj in ipairs(hot) do
      if obj.moving == 1 then
	 --DEBUG print(obj.x,obj.y)
	 obj.x,obj.y = love.mouse.getPosition()
      end
   end
end

function love.draw()
   for i,obj in ipairs(hot) do
      love.graphics.draw(obj.img,obj.x,obj.y,obj.r,1,1,79,79)
   end
end

function love.mousepressed(x,y,btn)
   for i,obj in ipairs(hot) do
      if x > obj.x and
	 x < obj.x + obj.img:getWidth() and
	 y > obj.y and
      y < obj.y + obj.img:getHeight() then
	 obj.moving = 1
	 obj.r = 0.3
      end
   end
end

function love.mousereleased(x,y,btn)
   for i,obj in ipairs(hot) do
      obj.moving = 0
      obj.r = 0
   end
end
