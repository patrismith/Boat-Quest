local playermanager = {}


function playermanager:init(xtile, ytile)

   self.location = {}
   self:teleport(xtile, ytile)

   dbug.show('playermanager loaded')

end


function playermanager:teleport(xtile, ytile)
   -- change the player's location, tilewise
   dbug.show('moving player to ' .. xtile .. ', ' .. ytile)
   self.location = { x = constants:tiletopx(xtile),
                     y = constants:tiletopx(ytile),
                     dir = 'down' }

   displaymanager:addSprite('player', self.location.x, self.location.y, 'player', 'up')

end


function playermanager:render()

   -- this whole function is only for displaying tile/px position
   if self.location then

      if dbugglobal then
         love.graphics.print('px: ' .. self.location.x .. ', ' .. self.location.y,0,0)
         love.graphics.print('tile: ' .. constants:pxtotile(self.location.x) .. ', ' .. constants:pxtotile(self.location.y),0,20)
      end

   end

end


function playermanager.draw()

   playermanager:render()

end


function playermanager:exit(dest)

   -- having this function be in playermanager
   -- seems a little unintuitive.
   events:checkAnchor()
   displaymanager:resetSprites()
   collisionmanager:clearAll()
   mapmanager:loadMap(dest.map)
   self:teleport(dest.xtile, dest.ytile)

end


function playermanager:update(dt)

   -- this is the moving part of the ride
   for k,v in pairs(constants.playerdir) do
      if love.keyboard.isDown(k) then

         self.location.dir = k

         -- this is where player is trying to move
         local xtemp = self.location.x + v.x
         local ytemp = self.location.y + v.y

         -- check if there's any special tiles in that area
         local collide, dest = collisionmanager:detect(xtemp, ytemp, constants.sprites.player[self.location.dir].w, constants.sprites.player[self.location.dir].h)

         if collide == false or collide == 'exit' then
            -- only move forward if we didn't hit a tile, or hit an exit tile
            self.location.x = xtemp
            self.location.y = ytemp
            if dest then
               dbug.show(dest.map)
               self:exit(dest)
            end
         end

         displaymanager:addSprite('player', self.location.x, self.location.y, 'player', k)

      end

   end

end


function playermanager:keypressed(key)


   -- this is the talking part of the ride
   -- we use spacebar to talk/check
   -- must be facing the object!
   if key == ' ' then

      local xtemp = self.location.x + constants.playerdir[self.location.dir].x
      local ytemp = self.location.y + constants.playerdir[self.location.dir].y

      local collide, name = collisionmanager:detect(xtemp, ytemp, constants.sprites.player[self.location.dir].w, constants.sprites.player[self.location.dir].h)

      if collide == 'npc' and name then
         npcmanager:talk(constants.currmap, name)
      end

      -- these are calls to hardcoded events in events.lua
      if name == 'whale' and not inventory:has('hook') then
         events:getItem('hook')
      elseif name == 'octopus' and not inventory:has('rope') then
         events:initMenu(name)
      elseif name == 'mermaid06' and not inventory:has('cross') then
         events:initMenu(name)
      end

   end


   if dbugglobal then
      if key == '1' then
         events:getItem('hook')
      elseif key == '2' then
         events:menuAnswer('octopus', '8')
      elseif key == '3' then
         events:menuAnswer('mermaid06', 'Please')
      end
   end

end


return playermanager
