local mapmanager = {}

function mapmanager.parse(f, t)

   -- populate an empty table with room data from a specially-formated textfile

   h = love.filesystem.newFile(f)
   data = h:read()
   h:close()

   local column, currroom, currexit
   for line in string.gmatch(data, '[^\n]+') do
      column = 0
      currroom = ""
      currexit = ""
      for word in string.gmatch(line, '[^:]+') do
         column = column + 1
         if column == 1 then
            t[word] = {}
            t[word].exit = {}
            currroom = word
         elseif column == 2 then
            t[currroom].music = word
         elseif column == 3 then
            t[currroom].map = word
         --below is the code for creating exits
         --it will break if the format is not followed!
         elseif (column + 1) % 5 == 0 then
            t[currroom].exit[word] = {}
            currexit = word
         elseif column % 5 == 0 then
            t[currroom].exit[currexit].xtile = word
         elseif (column - 1) % 5 == 0 then
            t[currroom].exit[currexit].ytile = word
         elseif (column - 2) % 5 == 0 then
            t[currroom].exit[currexit].destx = word
         elseif (column - 3) % 5 == 0 then
            t[currroom].exit[currexit].desty = word
         end
      end
   end

end


function mapmanager:init()

   npcmanager:init()
   self.rooms = {}
   self.parse(constants.mapFile, self.rooms)

   self:loadMap(constants.startingLoc.room)

end


function mapmanager:loadMap(mapName)

   constants.currmap = mapName
   self.map = ATL.Loader.load(self.rooms[mapName].map)

   for i in pairs(self.map.layers) do
      for x, y, tile in self.map(i):iterate() do
         if tile.properties.Solid then
            collisionmanager:addTile({xtile = x, ytile = y, id = 'solid'})
         end
      end
   end

   for k,v in pairs(self.rooms[mapName].exit) do
      dbug.show('exit ' .. k .. ' at ' .. v.xtile .. ', ' .. v.ytile .. ' to ' .. v.destx .. ', ' .. v.desty)
      collisionmanager:addTile({xtile = v.xtile, ytile = v.ytile, id = 'exit',
                                dest = {xtile = v.destx, ytile = v.desty, map = k}})
   end

   npcmanager:loadNPCs(mapName)

end


function mapmanager:changeMap()



end


function mapmanager.draw()

   mapmanager.map:draw()


end

return mapmanager
