local npcmanager = {}


local function strtobool(str)

   return str == 'true' and true or false

end


function npcmanager.parse(f, t)

   -- bad, evil copypaste

   h = love.filesystem.newFile(f)
   data = h:read()
   h:close()

   local column, currroom, currexit
   for line in string.gmatch(data, '[^\n]+') do
      column = 0
      currroom = ""
      currname = ""
      for word in string.gmatch(line, '[^:]+') do
         column = column + 1
         if column == 1 then
            if not t[word] then
               t[word] = {}
            end
            currroom = word
         elseif column == 2 then
            t[currroom][word] = {}
            currname = word
         elseif column == 3 then
            t[currroom][currname].img = word
         elseif column == 4 then
            t[currroom][currname].xtile = tonumber(word)
         elseif column == 5 then
            t[currroom][currname].ytile = tonumber(word)
         elseif column == 6 then
            t[currroom][currname].moves = strtobool(word)
         elseif column == 7 then
            t[currroom][currname].fights = strtobool(word)
         elseif column == 8 then
            t[currroom][currname].heals = strtobool(word)
         elseif column == 9 then
            t[currroom][currname].dialogue = {}
            t[currroom][currname].dialogue.pre = {}
            for phrase in string.gmatch(word, '[^/*]+') do
               table.insert(t[currroom][currname].dialogue.pre, phrase)
            end
         end
      end
   end

end


function npcmanager:init()

   self.npcs = {}
   self.parse(constants.npcFile, self.npcs)

end


function npcmanager:loadNPCs(map)

   if self.npcs[map] then
      for k,v in pairs(self.npcs[map]) do
         v.x = constants:tiletopx(v.xtile)
         v.y = constants:tiletopx(v.ytile)
         v.xtiletarget = v.xtile
         v.ytiletarget = v.ytile
         v.movetimer = math.random(1,50)
         self:createNPC(k,v)
      end
   end

end


function npcmanager:createNPC(key,val)

   displaymanager:addSprite(key,val.x,val.y,val.img)
   collisionmanager:addTile({xtile = constants:pxtotile(val.x), ytile = constants:pxtotile(val.y), id = 'npc', name = key})

end


function npcmanager:removeNPC(map, name)

   -- this permanently removes the NPC from the game
   self.npcs[map][name] = nil
   displaymanager:removeSprite(name)
   collisionmanager:removeNPC(name)

end

function npcmanager:talk(map, name)

   dialoguemanager:startDialogue(self.npcs[map][name].dialogue.pre or nil)

end


function npcmanager:move(map, name)

   local dir = constants.playerdirindex[math.random(#constants.playerdirindex)]
   local xtiletemp = self.npcs[map][name].xtile + constants.playerdir[dir].x
   local ytiletemp = self.npcs[map][name].ytile + constants.playerdir[dir].y

   collisionmanager:removeNPC(name)

   -- first make sure the new location won't be on an occupied tile
   local collide = collisionmanager:detect(constants:tiletopx(xtiletemp), constants:tiletopx(ytiletemp))
   -- then make sure the player isn't in that tile
   -- (player isn't in the collision list)
   local collide2 = collisionmanager:detect(playermanager.location.x,
                                            playermanager.location.y)

   if collide == false and collide2 ~= name then
      dbug.show(name .. ' tried to move ' .. dir)
      self.npcs[map][name].xtiletarget = xtiletemp
      self.npcs[map][name].ytiletarget = ytiletemp
   end

   npcmanager:createNPC(name, self.npcs[constants.currmap][name])

end


function npcmanager:fluidmove(k, v)

        if v.x < constants:tiletopx(v.xtiletarget) then
           v.x = v.x + 1
        elseif v.x > constants:tiletopx(v.xtiletarget) then
           v.x = v.x - 1
        elseif v.x == constants:tiletopx(v.xtiletarget) then
           v.xtile = v.xtiletarget
        end

        if v.y < constants:tiletopx(v.ytiletarget) then
           v.y = v.y + 1
        elseif v.y > constants:tiletopx(v.ytiletarget) then
           v.y = v.y - 1
        elseif v.y == constants:tiletopx(v.ytiletarget) then
           v.ytile = v.ytiletarget
        end

         collisionmanager:removeNPC(k)
         self:createNPC(k, v)

end


function npcmanager:update(dt)

   if self.npcs[constants.currmap] then
      for k,v in pairs(self.npcs[constants.currmap]) do

         if v.moves then

            v.movetimer = v.movetimer + 1

            if v.movetimer >= 1000 then
               self:move(constants.currmap, k)
               v.movetimer = math.random(1,500)
            end

            self:fluidmove(k, v)

         end

      end
   end

end

return npcmanager
