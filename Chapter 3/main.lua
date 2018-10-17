-- blackjack
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
]]--

require("card")

WIDE = 600 --or any value, such as 900
HIGH = 300 --or any value, such as 600
pad   = WIDE*0.04
scale = 0.33
suits = { "hearts","spades","clubs","diamonds" }
values = { "Ace","2","3","4","5","6","7","8","9","10","Jack","Queen","King" }
hand   = {}
total  = 0
comp   = {}
ai     = 0

hold   = false

love.window.setTitle(' Blackjack ')
love.window.setMode( WIDE, HIGH )

function love.load()
    math.randomseed(os.time())
    playback= Card.init("card","back")
    slot = playback.img:getWidth()*scale
    love.graphics.setBackgroundColor(0.3,0.5,0.3)
    font = love.graphics.setNewFont("font/ostrich-sans-regular.ttf",36)
    love.graphics.setColor(1,1,1) -- values 0 to 1
end

function love.update(dt)
	if tonumber(total) > 21 then
		hold = true
	end
end

function love.draw()
    love.graphics.printf("Click deck to deal.",pad,66,WIDE, 'left') 
    love.graphics.printf("Click anywhere to hold.",pad,122,WIDE, 'left')
	
    for i, card in ipairs(hand) do
       love.graphics.draw(card.img,pad*i,pad*i,0,scale,scale,0,0)
    end
    for i, card in ipairs(comp) do
       love.graphics.setColor(0.7,0.8,0.7)
       love.graphics.draw(card.img,(WIDE*0.33)+(76)+(pad*i),pad*i,0,scale,scale,0,0)
       love.graphics.setColor(1,1,1)
    end	
    love.graphics.draw(playback.img,WIDE-slot-pad,pad,0,scale,scale,0,0)

    if hold == false then
       love.graphics.printf("You: " .. total .. " vs. Computer: " .. ai, 0, HIGH-76,WIDE, 'center')
    else
       win = winner()
       love.graphics.printf("Winner: " .. win .. "!!", 0, HIGH-76,WIDE, 'center')
    end 
end

function cardgen()
    local c = math.random(1,4)
    local s = suits[c]
    local c = math.random(1,13)
    local v = values[c]
    card = Card.init(s,v)
    return card
end

function winner()
   if tonumber(total) <= 21
   and tonumber(total) > tonumber(ai) then
      win = "You"
   elseif tonumber(total) <= 21 
   and tonumber(ai) == tonumber(total) then
      win = "Tie"
   elseif tonumber(ai) > 21
   and tonumber(total) > 21 then
      win = "Bust"
   elseif tonumber(ai) > 21 
   and tonumber(total) <= 21 then
      win = "You"
   else
      win = "Computer"
   end
   return win
end

function face(c)
   if c == "Jack" 
      or c == "King"
   or c == "Queen" then
      val=10
--DEBUG print("JQK detected")
   elseif c == "Ace" then
      val=1
--DEBUG print("ace detected")
   else
      val=tonumber(c)
--DEBUG print("number detced")
   end
   return val
end

function reset()
   total = 0
   hand = {}
   comp = {}
   ai = 0
   hold = false
end

function love.mousereleased(x,y,button)
   if hold == true
   and total > 1 then
      reset()
   end
   -- computer
   if ai < 16 then
      var = cardgen()
      var = cardgen()
      comp[#comp+1]=var
      val = face(var.value)
      ai = ai+val
   end
   
   if button == 1 
      and x > WIDE-slot-pad
   and y < slot*1.5 then
      var = cardgen()
      hand[#hand+1]=var
      val = face(var.value)
      total = total+val
   elseif #hand >= 1 then
      hold = true
   end
end
