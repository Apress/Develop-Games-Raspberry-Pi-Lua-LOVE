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

require("room")
require("door")
require("hero")
require("chest")
require("trap")
require("monster")
require("floor")
require("bolt")

WIDE,HIGH = 960,720
love.window.setTitle(' Ultradimensional Permadungeon ')
love.window.setMode( WIDE, HIGH )

d = package.config:sub(1,1) --path separator
t = 32 --tile size

hist  = {} -- previous rooms, map not implemented
card  = {'n','e','s','w'}
doors = {} -- all doors in a room
chests = {}   -- all treasure chests in a room
traps  = {}   -- all traps in a room
monsters = {} -- all monsters in a room
bolts  = {}   -- magic missiles

local frame = 1     -- turn-based frame
local aframe = 1    -- animated frame
local fsize = 36     -- font size
local progress = 0
local permadeath = 0 -- is player dead yet
hot = {}
hot['x'] = nil
hot['y'] = nil
hot['name'] = nil

math.randomseed(os.time())

function love.load()
   -- underworld_load CC-BY-3.0 by poikilos
   -- based on these Redshrike's overworld sprites:
   -- door, quad swirl, basis for wall & creatures
   -- Stephen Challener (Redshrike)
   -- hosted by OpenGameArt.org)
   sheet = love.graphics.newImage("img" .. d .. "underworld_load-atlas-32x32.png")
   skull = love.graphics.newImage("img" .. d .. "underworld_load-sprites-flameskull-32x32.png")
   floor = Floor.init()    -- images for room tiles
   
   font = love.graphics.setNewFont("font/pixlashed-15.otf",fsize)
   love.graphics.setColor(1,1,1) -- values 0 to 1
   hero = Hero.init()
   love.first()

   music = love.audio.newSource("snd" .. d .. "happybattle.ogg", "stream")
   music:setLooping(true)
   love.audio.play(music)
end

function love.first()
   --a
   if hot['name'] == nil then
      hot['name'] = card[math.random(1,4)]
   end
   room = Room.init()
   love.door()
   --b
      --first time
   if hot['x'] == nil then
      print("You enter a dark dungeon.")
      -- set where hero is entering
      if hot['name'] == "n" then
	 hot['x'] = doors['n'].x
	 hot['y'] = doors['n'].y
      elseif hot['name'] == "e" then
	 hot['x'] = doors['e'].x
	 hot['y'] = doors['e'].y
      elseif hot['name'] == "w" then
	 hot['x'] = doors['w'].x
	 hot['y'] = doors['w'].y
      else
	 hot['x'] = doors['s'].x
	 hot['y'] = doors['s'].y
      end
      hero.x = hot['x']
      hero.y = hot['y']
      hist[#hist+1] = room
   end
   love.treasure()
   love.monster()
   love.trap()
end

function love.treasure()
   for i=0,room.treasure,1 do
      local j = Chest.init(room.w,room.h)
      chests[#chests+1] = j
   end
end

function love.monster()
   for i=0,room.monster,1 do
      local j = Monster.init(room.w,room.h)
      monsters[#monsters+1] = j
   end
end

function love.trap()
   for i=0,room.trap,1 do
      local j = Trap.init(room.w,room.h)
      traps[#traps+1] = j
   end
end

function love.door()
      --[[ DOORS ]]--

   if room.north then
      door = Door.init("n",room.w,room.h)
      doors['n'] = door
   end
   if room.east then
      door = Door.init("e",room.w,room.h)
      doors['e'] = door
   end
   if room.south then
      door = Door.init("s",room.w,room.h)
      doors['s'] = door
   end
   if room.west then
      door = Door.init("w",room.w,room.h)
      doors['w'] = door
   end
end

function love.blast(tgt)
   local count = #tgt
   for i=0, count do tgt[i]=nil end
end

function love.entrance()
   love.blast(chests)
   love.blast(bolts)
   love.blast(monsters)
   love.blast(traps)
   progress = 0
   --a
   room = Room.init()

   love.treasure()
   love.monster()
   love.trap()

   love.door()
   
   --[[ ACTIVE DOOR ]]--
   --b
   -- not first room
   if hot['name'] == 'n' then
      hero.x = doors['s'].x
      hero.y = doors['s'].y
   elseif hot['name'] == 's' then
      hero.x = doors['n'].x
      hero.y = doors['n'].y
   elseif hot['name'] == 'e' then
      hero.x = doors['w'].x
      hero.y = doors['w'].y
   else 
      hero.x = doors['e'].x
      hero.y = doors['e'].y
   end 
   hist[#hist+1] = room
end

function love.draw()
   --[[ WORLD ]]--
   love.graphics.setColor(1,1,1)
   love.background(room)

   for c=0, room.w, 1 do    -- for each column in room
      for r=0, room.h, 1 do -- for each row in room
	 if c == 0 then -- west wall 
	    love.graphics.draw(sheet,floor[2],t*c,t*r)
	    if room.west then love.graphics.draw(sheet,floor[3],doors['w'].x-t,trim(room,doors['w'].y),math.rad(-90),1,1,t/2,t/2) end
	 elseif c == room.w then -- east wall
	    love.graphics.draw(sheet,floor[2],t*c,t*r)
	    if room.east then love.graphics.draw(sheet,floor[3],doors['e'].x+t,trim(room,doors['e'].y),math.rad(90),1,1,t/2,t/2) end
	 else -- middle ground
	    love.graphics.draw(sheet,floor[1],t*c,t*r)
	 end -- if i

	 if r == 0 then -- north wall
	    love.graphics.draw(sheet,floor[2],t*c,t*r)
	    if room.north then love.graphics.draw(sheet,floor[3],trim(room,doors['n'].x),doors['n'].y-t) end
	 end -- if j

	 if r == room.h then -- south wall
	    love.graphics.draw(sheet,floor[2],t*c,t*r)
	    if room.south then love.graphics.draw(sheet,floor[3],trim(room,doors['s'].x),doors['s'].y+t,0,1,-1,0,t) end
	 end -- if j
      end --for j
   end --for i

   --[[ TRAPS ]]--
   for k,v in pairs(traps) do
      love.graphics.draw(sheet,v.img,v.x,v.y)
   end   

   --[[ TREASURE ]]--
   for k,v in pairs(chests) do
      love.graphics.draw(sheet,v.img,v.x,v.y)
   end

   --[[ MONSTERS ]]--
   for k,v in pairs(monsters) do
      love.graphics.draw(sheet,v.img,v.x,v.y)
   end   
   
   --[[ STATS ]]--
   if permadeath == 0 then
      love.graphics.printf("XP " .. hero.xp,t*2,HIGH-fsize,WIDE,'left')
   else
      love.graphics.printf("You have experienced PERMADEATH.",hero.x,hero.y,WIDE,'left')
   end
   
   --[[ BOLTS ]]--
   for k,v in pairs(bolts) do
      love.graphics.draw(skull,v.img,v.x,v.y)
   end   

   --[[ CHARACTER ]]--
   love.graphics.draw(sheet,hero.img,hero.x,hero.y)
end --draw

function trim(room,n)
   if n >= room.w*t then
      n=n-t
   elseif n < t then
      n=n+t+t
   end
   return n
end

function love.background(room)
   for c=0, WIDE, 1 do    -- for each column in room
      for r=0, HIGH, 1 do -- for each row in room
	 love.graphics.draw(sheet,room.phlogiston,t*c,t*r)
      end
   end
end

function love.update(dt)
   aframe = aframe+1
   if aframe >= 4 then
      aframe = 1
   end

   for k,v in pairs(bolts) do
      v.img = v.ani[aframe]
      if v.face == "e" then
	 v.x = v.x+v.speed
      elseif v.face == "w" then
	 v.x = v.x-v.speed
      elseif v.face == "n" then
	 v.y = v.y-v.speed
      elseif v.face == "s" then
	 v.y = v.y+v.speed
      end

      -- still in room?
      if v.x > (room.w*t)-(t*2) then
	 table.remove(bolts,k)
      elseif v.x < t then
         table.remove(bolts,k)
      elseif v.y > (room.h*t)-(t*2) then
	 table.remove(bolts,k)
      elseif v.y < t then
         table.remove(bolts,k)
      end

      --hit or miss
      for i,j in pairs(monsters) do
         if collide(v.x,v.y,j['x'],j['y']) and j.alive then
	    j.xp = j.xp-math.random(0,6)
	    table.remove(bolts,k)
	    if j.xp < 1 then
	    --[[   local drop = Chest.init(room.w,room.h)
	       drop.]]--
	       table.remove(monsters,i)
	    end
	 end
      end
   end
   
   if hero.xp < 1 then
      permadeath = 1
   end
end

function love.keypressed(key)
   frame = frame+1

   progress = progress+1
   
   if frame >= 3 then
      frame = 1
   end

   if hero.x < (room.w*t)-t and
      key == "right" or key == "d" then
	 hero.x = hero.x+hero.speed
	 hero.img = hero.ani[frame]
	 hero.face = "e"
   elseif hero.x > t and
      key == "left" or key == "a" then
	 hero.x = hero.x-hero.speed
	 hero.img = hero.ani[3+frame]
	 hero.face = "w"
   elseif hero.y > t and
      key == "up" or key == "w" then
	 hero.y = hero.y-hero.speed
	 hero.img = hero.ani[9+frame]
	 hero.face = "n"
   elseif hero.y < (room.h*t)-t and
      key == "down" or key == "a" then
	 hero.y = hero.y+hero.speed
	 hero.img = hero.ani[6+frame]
	 hero.face = "s"
   end

   --[[ TREASURE ]]--
   for k,v in pairs(chests) do
      if collide(hero.x,hero.y,v['x'],v['y']) and v.full then
	 hero.xp = hero.xp+v.xp      -- take gold
	 v.img = v.state[2] --close
	 v.full = false    -- mark empty
      end
   end

   --[[ TRAPS ]]--
   for k,v in pairs(traps) do
      if collide(hero.x,hero.y,v['x'],v['y']) and v.live then
	 hero.xp = hero.xp-v.dmg --take damage 
	 v.img = v.state[v.sel+2]   --change image
	 v.dmg = 1               --disarm
	 v.live = false          --mark not live
      end
   end

   --[[ start BATTLE ]]--
   for k,v in pairs(monsters) do
      if collide(hero.x,hero.y,v['x'],v['y']) and v.alive then
	 hero.xp = hero.xp-v.dmg --take damage 
	 v.battle = true
      end
   end

   if progress > 2 then
   for k,v in pairs(doors) do
      if collide(hero.x,hero.y,v.x,v.y) and v.go then
	 if hero.face == v.face then
	    hot['x'] = v.x
	    hot['y'] = v.y
	    hot['name'] = tostring(k)
	    love.entrance()
         end -- if
      end -- if
   end --for
   progress = 0
   end --if progress
end

function love.keyreleased(key)
   if key == "f" or key == "u" then
      local j = Bolt.init(hero.x,hero.y)
      bolts[#bolts+1] = j
      hero.xp = hero.xp-math.random(0,6)
   end

   --[[ MONSTERS ]]--
   for k,v in pairs(monsters) do
      if v.name == "fungus" then
	 if v.y < t*2 then
	    v.go = 0
	 elseif v.y > (room.h*t)-(t*2) then
	    v.go = 1
	 end
	 v.img = v.face[v.go+frame]
	 if v.go == 0 then
	    v.y = v.y+math.random(0,1)*t
	 else
	    v.y = v.y-math.random(0,1)*t
	 end

      elseif v.name == "golem" then -- ice golems
	 if v.x > (room.w*t)-(t*1) then ---(t*1) then
	    v.go = 1
	 elseif v.x < t*2 then
	    v.go = 0
	 end

	 v.img = v.face[v.go+frame]
	 if v.go == 0 then
	    v.x = v.x+t --math.random(0,1)*t
	 else
	    v.x = v.x-t --math.random(0,1)*t
	 end
      end 
   end
   if permadeath > 0 then
      permadeath = permadeath+1
   end

   if permadeath > 2 then
      os.exit()
   end
end


function collide(x1,y1,x2,y2)
   return x1 < x2+t and
      x2 < x1+t and
      y1 < y2+t and
      y2 < y1+t
end 

function love.mousepressed(x,y,button)
end

function love.mousereleased(x,y,button)
end
