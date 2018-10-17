--[[ GNU All-Permissive License

Copying and distribution of this file, with or without modification,
are permitted in any medium without royalty provided the copyright
notice and this notice are preserved.  This file is offered as-is,
without any warranty.

https://www.gnu.org/licenses/license-list.en.html ]]--

view_w = 777
view_h = 472

function love.load()                                                    
   -- loads once at launch
   love.window.setMode(view_w,view_h,{resizable=false, vsync=false})
   love.window.setTitle('DiCE')
   --	love.graphics.setBackgroundColor(24,24,24)
   math.randomseed(os.time())
   computer = math.random(1,20)
   player = math.random(1,20)
end

function love.draw()
   love.graphics.setColor(255, 255, 255)
   if player > computer then
      love.graphics.printf("Player wins!",0,view_h*0.5,view_w*0.5, 'center')
      -- print("player wins")
   else
      love.graphics.printf("Computer wins!",0,view_h*0.5,view_w*0.5, 'center')
      -- print("computer wins")
   end
end
