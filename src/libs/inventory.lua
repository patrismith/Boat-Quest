local inventory = {}


function inventory:generate(w)

   local t = {}
   t.w = w
   t.has = false

   return t

end


function inventory:init()

   self.inv = {}
   self.inv.rope = self:generate(224)
   self.inv.cross = self:generate(224)
   self.inv.hook = self:generate(224)

end


function inventory:has(item)

   dbug.show(self.inv[item].has and 'true' or 'false')
   return self.inv[item].has

end


function inventory:gain(item)

   dbug.show('player gained ' .. item)
   self.inv[item].has = true

end


function inventory:render()

   for k,v in pairs(self.inv) do
      love.graphics.drawq(constants.invsheet.img, v.has and constants.inventory[k].a or constants.inventory[k].b, self.inv[k].w,0)
   end

end


function inventory.draw()

   inventory:render()

end


return inventory
