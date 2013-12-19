local collisionmanager = {}


function collisionmanager:init()

   self.tiles = {}
   dbug.show('collision manager loaded')

end


function collisionmanager:clearAll()

   constants.clearTable(self.tiles)

end


function collisionmanager:addTile(params)

   -- expects:
   -- xtile
   -- ytile
   -- id: 'solid', 'exit'

   -- optional:
   -- dest: table with keys xtile, ytile, map (string)
   -- name: name of npc, used for looking up dialogue

   local params = params or {}
   local tbl = {}

   local toAdd = {xtile = tonumber(params.xtile), ytile = tonumber(params.ytile), id = params.id}

   if params.dest then
      dbug.show('exit added: ' .. params.dest.map)
      toAdd.dest = {xtile = tonumber(params.dest.xtile), ytile = tonumber(params.dest.ytile), map = params.dest.map}
   end

   if params.name then
      toAdd.name = params.name
   end

   table.insert(self.tiles, toAdd)

end


function collisionmanager:NPCfirst(name)

   table.sort(self.tiles, function(a,b) return a.name and (a.name == name) or false end)

end


function collisionmanager:moveNPC()



end

function collisionmanager:removeNPC(name)

   self:NPCfirst(name)
   table.remove(self.tiles, 1)

end


function collisionmanager:detect(x, y, tile)

   -- detect a square
   local xtile = constants:pxtotile(x)
   local ytile = constants:pxtotile(y)
   local xtile2 = constants:pxtotile(x+constants.tilesize-1)
   local ytile2 = constants:pxtotile(y+constants.tilesize-1)

   for i,v in ipairs(self.tiles) do
      --dbug.show(i .. " " .. v.xtile .. " " .. type(v.xtile))
      if ((xtile == v.xtile) or (xtile2 == v.xtile)) and ((ytile == v.ytile) or (ytile2 == v.ytile)) then
         dbug.show('collision registered at ' .. xtile .. ', ' .. ytile .. ', ' .. v.id)
         -- if it is an exit tile, v.dest will be set
         -- if it is an npc, v.name will be set
         return v.id, v.dest or v.name or nil
      end
   end

   return false

end


function collisionmanager:render()

   --[[
   if dbugglobal then
      for i,v in ipairs(self.solidTiles) do
         love.graphics.rectangle("line", self:tiletopx(v.xtile), self:tiletopx(v.ytile), constants.tilesize, constants.tilesize)
      end
   end
   ---]]

end


function collisionmanager.draw()

   collisionmanager:render()

end



return collisionmanager
