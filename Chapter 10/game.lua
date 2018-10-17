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
require("msg")
require("table_save")
require("saver")

local inifile = require('inifile')

game = {}

home = os.getenv('HOME')
d    = package.config:sub(1,1) -- path separator
datadir = home .. d .. '.local' .. d .. 'share' .. d
confdir = home .. d .. '.config' .. d .. 'battlejack' .. d
hand  = {} --player hand
horde = {} --ai hand
deck  = {} --player deck
ai    = {} --ai deck
back  = {}
grab  = {} --selected for battle
up    = {} --powerups
earn  = {} --earned bonuses
conf  = {}
winner  = nil
level   = 0
lastwon = 0
ratio   = 1.37
-- parse the INI file and
-- put values into a table called set
set = inifile.parse('deck.ini')
local glow = love.graphics.newImage('img' .. d .. 'glow.png')
local shadow = love.graphics.newImage('img' .. d .. 'shadow.png')

local mana = love.graphics.newImage('img' .. d .. 'part.png')
parti = love.graphics.newParticleSystem(mana, 12)
parti:setParticleLifetime(2,5) -- Particles live span min,max
parti:setEmissionRate(4)
parti:setSizeVariation(1)
parti:setLinearAcceleration(-12,-12,12,0) --xmin,ymin,xmax,ymax
parti:setColors(255,255,255,255,255,255,255,0) --Fade

math.randomseed(os.time())

function game.load()
   game.cleanup()
   if saver.exists( confdir .. 'battlejack.ini' ) then
      local userconf = inifile.parse( confdir .. 'battlejack.ini', "io" )
      level = userconf['user']['level']
   else
      print("no user INI found")
   end

   game.background()

   --get deck states
   if saver.exists( datadir .. d .. 'battlejack' .. d .. 'hand.tbl' ) then
      tbl = table.load( datadir .. d .. 'battlejack' .. d .. 'hand.tbl' )
   end

   --build decks
   for i,obj in pairs(tbl) do
      card = Card.init(obj['color'],obj['value'],obj['face'],obj['x'],obj['y'])
      hand[#hand+1] = card
   end
   
   if saver.exists( datadir .. d .. 'battlejack' .. d .. 'horde.tbl' ) then
      tbl = table.load( datadir .. d .. 'battlejack' .. d .. 'horde.tbl' )
   end

   for i,obj in pairs(tbl) do
      card = Card.init(obj['color'],obj['value'],obj['face'],obj['x'],obj['y'])
      horde[#horde+1] = card
   end

      --get deck states
   if saver.exists( datadir .. d .. 'battlejack' .. d .. 'deck.tbl' ) then
      deck = table.load( datadir .. d .. 'battlejack' .. d .. 'deck.tbl' )
   end
   if saver.exists( datadir .. d .. 'battlejack' .. d .. 'ai.tbl' ) then
      ai = table.load( datadir .. d .. 'battlejack' .. d .. 'ai.tbl' )
   end

   game.backs()
   game.activate()
end

function game.cleanup()
   collectgarbage()
   game.blast(deck)
   game.blast(ai)
   game.blast(hand)
   game.blast(horde)
   game.blast(back)
   game.blast(grab)
   winner   = nil
   progress = 0
   scale = game.scaler(WIDE,790)
end

function game.new()
   game.cleanup()
   -- start new game
   game.activate()
--   math.randomseed(os.time())
   game.setup()
end

function game.scaler(WIDE,card)
   slot = WIDE/6
   scale = slot/card
   pad = WIDE*0.04
   return scale
end

function game.backs()
   -- create GUI decks
   -- hand back
   card = Card.init("c","v","back",pad,HIGH-(slot*ratio)-pad) --HIGH-slot-(pad*2))
   back[#back+1] = card

   -- horde back
   card = Card.init("c","v","back",WIDE-(slot/2)-pad,slot-(pad))
   back[#back+1] = card
end

function game.setup()
   game.backs()
   -- create sets
   deck = game.setsplit("card",1,deck,2)
   ai = game.setsplit("card",0,ai,2)
   up = game.setsplit("up",1,up,1)
   earn = game.setsplit("earn",1,earn,1)
   
   --steal cards from black
   if level < 2 then
      game.mole(ai,deck,4)
   else
      game.mole(ai,deck,6)
   end
   --insert joker
   deck = game.adder(deck,1,"joker",0,0)
   --ai   = game.adder(ai,0,"joker",0)
   --power ups
   if level > 0 then
      local limit = level
      if level > 8 then limit = 8 end
      for i = 1, limit, 1 do
	 c,f,v = up[i]:match("([^,]+),([^,]+),([^,]+)")
	 deck = game.adder(deck,1,f,v,1)
      end
      upcard = Card.init("bonus",v,f,WIDE/2,HIGH/2)
      -- earned bonuses
      local limit = level
      if level > 5 then limit = 5 end
      for i = 1, limit, 1 do
	 c,f,v = earn[i]:match("([^,]+),([^,]+),([^,]+)")
	 deck = game.adder(deck,1,f,v,0)
      end
      earncard = Card.init(c,v,f,WIDE/2,HIGH/2)
      if lastwon == 1 then
	 message="New cards added to your deck!"
	 msg.activate(earncard,upcard,message)
      end
   end

   --shuffle
   deck = game.shuffle(deck)
   ai = game.shuffle(ai)

   game.background()
end

function game.background()
   ground = love.graphics.newQuad(0,0,WIDE,HIGH,150,150)
   tile   = love.graphics.newImage('img' .. d .. 'tile.jpg')
   tile:setWrap('repeat','repeat')
end

function love.update(dt)
   if #grab > 0 then
      parti:update(dt)
   end
   handval=0
   hordeval=0
   for i,obj in pairs(hand) do
      handval = handval+tonumber(obj.value)
      if obj.color == "bonus" then
	 handval = handval-tonumber(obj.value)
      end
   end
   for i,obj in pairs(horde) do
      hordeval = hordeval+tonumber(obj.value)
   end
   -- ID the winner
   if handval >= 21 and handval > hordeval then
      winner = "hand"
   elseif hordeval >= 21 and hordeval > handval then
      winner = "horde"
   elseif handval >= 21 and handval == hordeval then
      winner = "tie"
   end
end

function game.activate()
   -- switch to game screen
   STATE = game
   ground = love.graphics.newQuad(0,0,WIDE,HIGH,150,150)
   font = love.graphics.setNewFont("font/Arkham_reg.TTF",72)
   
   if fsupdated == 1 then
      scale = game.scaler(WIDE,790)

      local arr = {hand,horde,back,grab}
      for i,tbl in ipairs(arr) do
	 for n,obj in pairs(tbl) do
	    obj.wide = obj.img:getWidth()*scale
	    obj.high = obj.img:getHeight()*scale
	 end
      end
      fsupdated = 0
   end
end

function game.draw()
   love.graphics.setColor(1,1,1)
   -- set background
   love.graphics.draw(tile,ground,0,0)
   --hand player
   font = love.graphics.setNewFont("font/Arkham_reg.TTF",36)

   card = back[1]
   love.graphics.draw(glow,pad,HIGH-slot-(slot*ratio),0,scale,scale,0,0)
   love.graphics.draw(card.img,pad,HIGH-(slot*ratio)-pad,0,scale,scale,0,0)

   love.graphics.setColor(0,0,0)
   love.graphics.printf(tostring(handval),(slot)-slot/2,HIGH-(slot*ratio)-pad-pad,slot/2,'center')
   love.graphics.setColor(1,1,1)
   --horde ai
   card = back[2]
   love.graphics.draw(shadow,WIDE-(slot)-pad,slot+(slot/4),0,scale,scale,0,0)
   
   love.graphics.draw(card.img,WIDE-pad,slot+pad+slot/4,0,-1*scale,-1*scale,0,0)
   love.graphics.setColor(0.8,0.1,0.1)
   --love.graphics.printf(tostring(hordeval),card.x-pad,card.y+card.y,slot/2,'center')
   love.graphics.printf(tostring(hordeval),WIDE-(slot/2)-pad*2,(slot*ratio)+pad,slot/2,'center')
   love.graphics.setColor(1,1,1)
   font = love.graphics.setNewFont("font/Arkham_reg.TTF",72)

   if progress < 2 then
      love.graphics.printf("Level " .. level,0,HIGH-(slot*ratio)-(pad*ratio)-72,WIDE,'center')
   end

   if winner == "hand" then
      lastwon = 1
      --love.graphics.printf("You have won!",0,(slot*ratio)+(pad*ratio)-72,WIDE,'center')
      love.graphics.printf("You have won!",0,HIGH-(slot*ratio)-(pad*ratio)-72,WIDE,'center') 
   elseif winner == "horde" then
      lastwon = 0
      --love.graphics.printf("You have lost.",0,(slot*ratio)+(pad*ratio)-72,WIDE,'center')
      love.graphics.printf("You have lost.",0,HIGH-(slot*ratio)-(pad*ratio)-72,WIDE,'center')
   elseif winner == "tie" then
      lastwon = 0
      --love.graphics.printf("Tied game.",0,(slot*ratio)+(pad*ratio)-72,WIDE,'center')
      love.graphics.printf("Tied game.",0,HIGH-(slot*ratio)-(pad*ratio)-72,WIDE,'center')      
   end

   -- draw cards 
   for i,obj in pairs(horde) do --ai
      obj.x = WIDE-(slot*i)-slot/2
      love.graphics.draw(obj.img,obj.x,obj.y,0,scale,scale,0,0) 
   end

   for i,obj in pairs(grab) do
      local count = 1
      while count < obj.wide/mana:getWidth() do
	 obj.y=HIGH-(slot*ratio)-pad*2
	 love.graphics.draw(parti,obj.x+(mana:getWidth()*count+1),obj.y+32/2)
	 count = count+1
      end

   end

   for i,obj in pairs(hand) do --player
      if game.isselected(obj,grab) then
	 love.graphics.draw(obj.img,obj.x,obj.y,0,scale,scale,0,0)   
      else
	 obj.x = pad+(slot*i)
	 obj.y = HIGH-(slot*ratio)-pad
	 love.graphics.draw(obj.img,obj.x,obj.y,obj.r,scale,scale,0,0)
      end
   end
end

function game.cardgen(src)
   local count = 0
   while src[count] == nil do count = count+1 end
   local c,f,v = src[count]:match("([^,]+),([^,]+),([^,]+)")
   card = Card.init(c,v,f,nil,nil)
   src[count] = nil

   if src == deck then
      hand[#hand+1] = card
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

function game.shuffle(tbl) -- shuffles numeric indices
   local len = #tbl
   for i = len, 1, -1 do
      local j = math.random( 1, i );
      tbl[i], tbl[j] = tbl[j], tbl[i];
   end
   return tbl;
end

function game.adder(tbl,human,card,v,bonus)
   if bonus == 1 then
      color="bonus"
   elseif bonus == 0 and human == 1 then
      color="red"
   else
      color="black"
   end
   tbl[#tbl+1] = color .. "," .. card .. "," .. tostring(v)
   return tbl;
end

function game.keypressed(k)
    if k == "escape" then
        menu.activate()
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

function game.isselected(src,tgt)
   for k,v in pairs(tgt) do
      if v==src then
	 return k
      end
   end
end

function game.blast(tgt)
   local count = #tgt
   for i=0, count do tgt[i]=nil end
end

function game.mousepressed(x,y,btn)
   if btn == 1 then
      for i,obj in pairs(hand) do
	 if game.clicker(x,y,obj) and not game.isselected(obj,grab) then
	    obj.r = 0
	    obj.y = obj.y - (slot*2*scale)
	    grab[#grab+1] = obj
	 elseif game.clicker(x,y,obj) and game.isselected(obj,grab) > 0 then
	    obj.r = 0
	    obj.y = HIGH-(pad*2)-slot
	    k = game.isselected(obj,grab)
	    grab[k] = nil
	 end
      end
   end
end

function game.postbattle(src,tgt)
   for i,card in ipairs(src) do --remove grabbed cards
      k = game.isselected(card,src)
      src[k] = nil
      k = game.isselected(card,tgt)
      table.remove(tgt,k)
   end
end

function game.totaler(tbl)
   local total = 0
   for i,obj in pairs(tbl) do
      total = total+tonumber(obj.value)
   end
	 
   return ( tonumber(total) >= 21 )
end

function game.sleep(s)
   local ntime = os.clock() + s
   repeat until os.clock() > ntime
end

function game.mousereleased(x,y,btn)
   local attack = 0
   progress = progress+1

   if btn == 1 and winner ~= nil then
      if winner == "hand" then
	 level = level+1
      end
      game.sleep(1)
      game.new()
   end
   
   if btn == 1 and #grab > 0 then
      for i,obj in pairs(horde) do     --examine each card in horde
	 if game.clicker(x,y,obj) then --get horde card that got clicked

	    for i,card in pairs(grab) do --check value of grabbed cards
	       attack = attack+tonumber(card.value) --add value to total attack

	       if card.face == "joker" then
		  game.blast(horde)
		  game.postbattle(grab,hand)
		  collectgarbage()
	       end
	    end

	    if attack >= tonumber(obj.value) then
	       -- remove from horde
	       k = game.isselected(obj,horde)
	       table.remove(horde,k)
	       game.postbattle(grab,hand)
	    end
	 end
      end
   elseif btn == 1 then
      --take a card
      for i,obj in pairs(back) do
	 if game.clicker(x,y,obj) and y > HIGH-slot-pad then
	    card = game.cardgen(deck)
	    if card.color == "black" then
	       -- insert card into horde
	       card.y = pad/4
	       horde[#horde+1] = card
	       message="Black card drawn!"
	       earncard = nil
	       upcard = card
	       msg.activate()
	       -- remove card from hand
	       hand[#hand] = nil
	    elseif card.color == "bonus" then
	       card = game.cardgen(deck)
	       if card.color == "black" then
		  -- insert card into horde
		  card.y = pad/4
		  horde[#horde+1] = card
		  hand[#hand] = nil
	       end
	    end
	    card = game.cardgen(ai)
	 end
      end
   end --if
end
