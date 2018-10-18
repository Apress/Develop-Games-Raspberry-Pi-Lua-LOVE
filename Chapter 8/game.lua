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

require("card")
local inifile = require('inifile')
game = {}

-- rot = 1
home = os.getenv('HOME')
d    = package.config:sub(1,1) -- path separator
hand  = {} --player hand
horde = {} --ai hand
deck  = {} --player deck
ai    = {} --ai deck
back  = {}
grab  = {} --selected for battle
winner = nil
proc = 0
hit = 0

-- parse the INI file and
-- put values into a table called set
set = inifile.parse('deck.ini')

local mana = love.graphics.newImage('img' .. d .. 'part.png')
parti = love.graphics.newParticleSystem(mana, 12)
parti:setParticleLifetime(2,5) -- Particles live span min,max
parti:setEmissionRate(4)
parti:setSizeVariation(1)
parti:setLinearAcceleration(-12,-12,12,0) --xmin,ymin,xmax,ymax
parti:setColors(255,255,255,255,255,255,255,0) --Fade

function love.update(dt)
   if #grab > 0 then
      parti:update(dt)
   end
end

function game.new()
   game.blast(deck)
   game.blast(ai)
   game.blast(hand)
   game.blast(horde)
   game.blast(back)
   winner   = nil

   math.randomseed(os.time())
   scale = game.scaler(WIDE,790)
   -- start new game
   STATE = game
   game.setup()

end

function game.scaler(WIDE,card)
   slot = WIDE/6
   -- for better performance, scale DECREASE the graphic 
   -- files and INCREASE the slot size
   scale = slot/card
   return scale
end

function game.setup()
   -- create GUI decks
   card = Card.init("c","v","back",pad,HIGH-slot-(pad*2))
   back[#back+1] = card
   
   card = Card.init("c","v","back",WIDE-(slot/2)-pad,slot-(pad))
   back[#back+1] = card

   ground = love.graphics.newQuad(0,0,WIDE,HIGH,150,150)
   tile   = love.graphics.newImage('img' .. d .. 'tile.jpg')
   tile:setWrap('repeat','repeat')

      -- create sets
   deck = game.setsplit("card",1,deck,2)
   ai = game.setsplit("card",0,ai,2)
   -- steal cards from black
   game.mole(ai,deck,6)   
   -- insert joker
   deck = game.joker(deck,1)
   ai   = game.joker(ai,0)
   -- shuffle
   deck = game.shuffle(deck)
   ai = game.shuffle(ai)

   print("deck -----------------")
   for i,card in pairs(deck) do
      print(card)
   end
   print("ai -----------------")
   for i,card in pairs(ai) do
      print(card)
   end
   
end

function game.activate()
   -- switch to game screen
   STATE = game
end

function game.draw()
   love.graphics.push()
   love.graphics.setColor(1,1,1)

   -- set background
   love.graphics.draw(tile,ground,0,0)
   
   -- draw cards 
   for i,obj in pairs(horde) do --ai
      obj.x = WIDE-(slot*i)-slot-pad
      love.graphics.draw(obj.img,obj.x,obj.y,0,scale,scale,0,0) 
   end

   for i,obj in pairs(grab) do
      local count = 1
      while count < obj.wide/mana:getWidth() do
	 love.graphics.draw(parti,obj.x+(mana:getWidth()*count+1),obj.y+(pad/3))
	 count = count+1
      end
   end
      
   for i,obj in pairs(hand) do --player
      obj.x = pad+(slot*i)
      love.graphics.draw(obj.img,obj.x,obj.y,obj.r,scale,scale,0,0)
   end

   --hand player
   card = back[1]
   love.graphics.draw(card.img,card.x,card.y,0,scale,scale,0,0)
   --horde ai
   card = back[2]
   love.graphics.draw(card.img,card.x,card.y,0,-1*scale,-1*scale,card.img:getWidth()/2, card.img:getHeight()/2)

   love.graphics.pop()
end

function game.isselected(src,tgt)
   for k,v in pairs(tgt) do
      if v==src then
	 return k
      end
   end
end

function game.cardgen(src)
   local count = 0
   while src[count] == nil do count = count+1 end
   c,f,v = src[count]:match("([^,]+),([^,]+),([^,]+)")
   card = Card.init(c,v,f,nil,nil)
   src[count] = nil

   if src == deck then
      hand[#hand+1] = card
--      card.x = (pad) + (slot*#hand)
      card.y = HIGH-(pad*2)-slot
   else
      horde[#horde+1] = card
      card.y = pad/4
   end 
   return card
end

function game.setsplit(stack,human,tbl,n)
   for count = 1, n do
      for i,card in pairs(set[stack]) do
	 -- DEBUG 	 print(i,card)
	 if human == 1 then
	    color="red"
	 else
	    color="black"
	 end
	 tbl[#tbl+1]=color .. "," .. card
      end
   end
   return tbl
end

function game.mole(src,tgt,n)
   -- shuffle 
   src = game.shuffle(src)
   
   for count = 1, n do
      tgt[#tgt+1] = src[count]
      table.remove(src,count)
   end
end

-- https://stackoverflow.com/a/32167188/4521815
function game.shuffle(tbl) -- shuffles numeric indices
   local len = #tbl
   for i = len, 1, -1 do
      local j = math.random( 1, i );
      tbl[i], tbl[j] = tbl[j], tbl[i];
   end
   return tbl;
end

function game.joker(tbl,human)
   if human == 1 then
      color="red"
   else
      color="black"
   end
   tbl[#tbl+1] = color .. ",joker,0"
   return tbl;
end

function game.blast(tgt)
   local count = #tgt
   for i=0, count do tgt[i]=nil end
end

function game.postbattle(src,tgt)
   for i,card in ipairs(src) do --remove grabbed cards
      k = game.isselected(card,src)
      src[k] = nil
      k = game.isselected(card,tgt)
      table.remove(tgt,k)
   end
end

function game.keypressed(k)
    if k == "escape" then
        menu.activate()
    end
end

function love.mousepressed(x,y,btn)
   if btn == 1 then
      for i,obj in pairs(hand) do
	 if game.clicker(x,y,obj) and not game.isselected(obj,grab) then
	    obj.y = obj.y - (slot*2*scale)
	    grab[#grab+1] = obj
	 elseif game.clicker(x,y,obj) and game.isselected(obj,grab) > 0 then
	    obj.y = HIGH-(pad*2)-slot
	    k = game.isselected(obj,grab)
	    grab[k] = nil
	 end
      end
   end
end

function game.clicker(x,y,tgt)
   return (
        x < tgt.x + tgt.wide and
        x > tgt.x and
        y < tgt.y + tgt.high and
        y > tgt.y
    )
    -- returns True or False
end

function game.mousereleased(x,y,btn)
   local attack = 0
   
   if btn == 1 and #grab > 0 then
      for i,obj in pairs(horde) do     --examine each card in horde
	 if game.clicker(x,y,obj) then --get horde card that got clicked

	    for i,card in pairs(grab) do --check value of grabbed cards
	       attack = attack+tonumber(card.value) --add value to total attack

	       if card.face == "joker" then
		  game.blast(horde)
		  game.postbattle(grab,hand)
	       end
	    end
	    
	    if attack > tonumber(obj.value) then
	       -- remove from horde
	       k = game.isselected(obj,horde)
	       table.remove(horde,k)
	       game.postbattle(grab,hand)
	    end
	 end
      end      
   elseif btn == 1 and hit == 0 then
      --take a card
      for i,obj in pairs(back) do
	 if game.clicker(x,y,obj) and y > HIGH-slot-pad then
	    card = game.cardgen(deck)
	    card = game.cardgen(ai)
	    -- hit = 1  SET THIS AFTER A CARD IS DRAWN
	 end
      end

   end --if
end
