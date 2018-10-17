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

package.path = package.path .. ';local/share/lua/5.3/?.lua'
inifile = require('inifile')

saver = {}

function saver.exists(path)
   local success, err, num = os.rename(path, path)
   if not success and num == 13 then
         return true
   end
   return success
end

function saver.isfile(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
end

function saver.gamedata()
   if not saver.exists(datadir .. 'battlejack') then
      os.execute("mkdir " .. datadir .. 'battlejack')
   end
   --current hand
   table.save(hand,datadir .. 'battlejack' .. d .. 'hand.tbl')
   --current horde
   table.save(horde,datadir .. 'battlejack' .. d .. 'horde.tbl')
   --current masterdecks
   table.save(deck,datadir .. 'battlejack' .. d .. 'deck.tbl')
   table.save(ai,datadir .. 'battlejack' .. d .. 'ai.tbl')
end

function saver.userdata()
   conf.user = {}
   --   level
   conf.user.level = tostring(level)
   conf.user.fullscreen,fstype = love.window.getFullscreen()
   
   if not saver.exists(confdir) then
      os.execute("mkdir -p " .. confdir)
   end

   inifile.save( confdir .. d .. 'battlejack.ini', conf, "io" )
   --status = xpcall( save.writeconf, save.catcherr )
end

function saver.writeconf()
   inifile.save( confdir .. d .. 'battlejack.ini', conf, "io" )
end

function saver.catcherr( err )
   print( "ERROR:", err )
end
