-- Dice game
-- by Seth Kenlon

--[[ GNU General Public License v3
    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.
--]]
    
computer = {}
human   = {}
cw = 777
ch = 472

function love.load()
   love.window.setTitle('DiCE')
   love.window.setMode(cw,ch,{resizable=false, vsync=false})
   love.graphics.setBackgroundColor(0,0,0)
   math.randomseed(os.time())
   human.img = love.graphics.newImage('img/digital-die0.png')
   human.win = false
   computer.img = love.graphics.newImage('img/digital-die0.png')
   start = true
   human.name = "human"
   computer.name = "Computer"
   font = love.graphics.setNewFont("font/orbitron-bold-webfont.ttf",72)
end

function love.draw()
   if start == false then
      if human.win == true then
	 love.graphics.setColor(20/255, 255/255, 20/255)
	 love.graphics.printf("human wins!", 0, ch-76,cw, 'center')
      else
	 love.graphics.setColor(255/255, 20/255, 20/255)
	 love.graphics.printf("Computer wins!", 0, ch-76,cw, 'center')
      end
   else
      love.graphics.printf("Click to roll", 0, ch-76,cw, 'center')
   end
   love.graphics.draw(human.img,33,30,0,0.2,0.2)
   love.graphics.draw(computer.img,cw*0.5,30,0,0.2,0.2)
end

function love.mousereleased()
   start = false
   computer.roll = math.random(1,6)
   human.roll = math.random(1,6)
   human.img = love.graphics.newImage('img/digital-die'..human.roll..'.png')
   computer.img = love.graphics.newImage('img/comp-die'..computer.roll..'.png')

   if human.roll > computer.roll then
      human.win = true
   else
      human.win = false
   end
end
