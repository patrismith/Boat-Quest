local inventory = {}


function inventory:generate(w)

   local t = {}
   t.w = w
   t.has = false

   return t

end


function inventory:init()

   self.inv = {}
   self.inv.rope = self:generate(200)
   self.inv.cross = self:generate(210)
   self.inv.hook = self:generate(220)

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
      if v.has == false then
         love.graphics.setColor(0,0,0)
         love.graphics.rectangle("line",v.w,0,8,8)
         love.graphics.setColor(255,255,255)
      else
         love.graphics.setColor(255,255,255)
         love.graphics.rectangle("fill",v.w,0,8,8)
      end
   end

end


function inventory.draw()

   inventory:render()

end


return inventory
