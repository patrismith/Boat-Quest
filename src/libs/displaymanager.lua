local displaymanager = {}


function displaymanager:init()

   self.canvas = love.graphics.newCanvas(256,240)
   self.canvas:setFilter("nearest","nearest")

   -- let's store the draw functions of other modules in this table
   self.drawfunctions = {}

   -- sprites!
   self.sprites = {}
   self.spriteindex = {}

   self.spriteanim = 0

   dbug.show('displaymanager loaded')

end


function displaymanager:addDrawFuncs(funcs)

   -- add a list of functions, in order, to the drawfunction table
   for i,v in ipairs(funcs) do
      table.insert(self.drawfunctions, v)
   end

end


function displaymanager:clearDrawFuncs()

   -- erase all the drawfunctions
   constants.clearTable(self.drawfunctions)

end


function displaymanager:resetSprites()

   -- erase all the sprite tables
   constants.clearTable(self.sprites)
   constants.clearTable(self.spriteindex)

end


function displaymanager:addSprite(name, x, y, img, frame)

   -- add a player or npc sprite to a key table
   -- if the sprite already exists (as identified by name),
   -- then update the x/y values of the sprite

   if not self.sprites[name] then
      self.sprites[name] = {}
   end

   self.sprites[name].x = x
   self.sprites[name].y = y

   self.sprites[name].img = img
   self.sprites[name].frame = frame

   self:updateSpriteindex()

end


function displaymanager:removeSprite(name)

   self.sprites[name] = nil
   self:updateSpriteindex()

end


function displaymanager:updateSpriteindex()

   -- add sprites from the key table (self.sprites) to this indexed table
   -- so we can sort them all by y-position

   -- this function is called every time a y-position changes, or a sprite is added or erased

   -- wipe the table of old sprites
   constants.clearTable(self.spriteindex)

   for k,v in pairs(self.sprites) do
      table.insert(self.spriteindex, {img = v.img, frame = v.frame, x = v.x, y = v.y})
   end

   -- sort table by y value
   table.sort(self.spriteindex, function(a,b) return a.y<b.y end)

end


function displaymanager:renderSprites()


   for i,v in ipairs(self.spriteindex) do
      love.graphics.drawq(constants.charsheet.img, constants.sprites[v.img][v.frame].a, v.x, v.y)
      --[[
      if dbugglobal then
         love.graphics.setColor(255,0,0)
         love.graphics.rectangle("line",v.x,v.y,constants.sprites[v.img][v.frame].w,constants.sprites[v.img][v.frame].h)
         love.graphics.setColor(255,255,255)
      end
      --]]

   end

end


function displaymanager.drawSprites()

   displaymanager:renderSprites()

end


function displaymanager:draw()

   if self.canvas and self.drawfunctions then
      -- canvas wrapper begin
      love.graphics.setCanvas(self.canvas)
      self.canvas:clear()
      love.graphics.setBlendMode('alpha')
      ----------------------

      -- run draw functions from a table
      for _,v in ipairs(self.drawfunctions) do
         v()
      end

      -- canvas wrapper end
      love.graphics.setCanvas()
      love.graphics.setBlendMode('premultiplied')
      love.graphics.draw(self.canvas,0,0,0,scale)
      ---------------------
   end

end


function displaymanager:update(dt)

   -- handling optional sprite animations
   self.spriteanim = self.spriteanim + dt
   if self.spriteanim >= 1 then
      self.spriteanim = self.spriteanim - 1
      for k,v in pairs(constants.sprites) do
         for k2,v2 in pairs(v) do
            if v2.a and v2.b then
               v2.a, v2.b = v2.b, v2.a
            end
         end
      end
   end


end

return displaymanager
