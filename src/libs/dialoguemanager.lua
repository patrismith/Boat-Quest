local dialoguemanager = {}


function dialoguemanager:init()

   self.boxes = {}
   self.currbox = 1
   self.menuitems = {}
   self.curritem = 1
   self.menu = ""

end


function dialoguemanager:addBox(tbl, t)

   t = t or self.boxes

   for i,phrase in ipairs(tbl) do
      dbug.show('adding ' .. phrase .. ' to dialogue')
      table.insert(t, phrase)
   end

end


function dialoguemanager:clearAll(t)

   local t = t or self.boxes

   constants.clearTable(t)
   self.currbox = 1
   self.curritem = 1

end


function dialoguemanager:startDialogue(tbl)

   if tbl then
      dialoguemanager:addBox(tbl)
      self.currbox = 1
      gamemanager:setState('dialogue')
   end

end


function dialoguemanager:endDialogue(menu)


   if not self.menuitems[1] then
      gamemanager:setState('normal')
   end

   if menu then
      dialoguemanager:clearAll(self.menuitems)
   else
      dialoguemanager:clearAll()
   end

   if not self.menuitems[1] then
      gamemanager:setState('normal')
   end

end


function dialoguemanager:endMenu(menu)

   events:menuAnswer(self.menu, self.menuitems[self.curritem + 1])
   dialoguemanager:endDialogue(true)

end


function dialoguemanager:startMenu(menu, tbl)

   if tbl then
      self.menu = menu
      dialoguemanager:addBox(tbl,self.menuitems)
      gamemanager:setState('dialogue')
   end
end


function dialoguemanager:box(x,y,w,h)

   love.graphics.draw(dialoguebg, x, y)

   --[[
   love.graphics.setColor(0,0,0)
   love.graphics.rectangle("fill",x,y,w,h)
   love.graphics.setColor(255,255,255)
   love.graphics.rectangle("fill",x+2,y+2,w-4,h-4)
   love.graphics.setColor(0,0,0)
   love.graphics.rectangle("fill",x+4,y+4,w-8,h-8)
   love.graphics.setColor(255,255,255)
   --]]

end


function dialoguemanager:printDialogue(text)

   love.graphics.setColor(50,10,20)
   love.graphics.printf(text,11,21*8+11,31*8-23,"left")
   love.graphics.setColor(255,255,255)

end


function dialoguemanager:render()

   self:box(0,21*8,32*8,8*8)


   if self.boxes[1] then
      self:printDialogue(self.boxes[self.currbox])
   elseif self.menuitems[1] then
      local tempstr = ""
      for i,v in pairs(self.menuitems) do
         ---[[
         if i == 1 then
            tempstr = tempstr .. v .. '\n\n'
         else
            if self.curritem == i - 1 then
               tempstr = tempstr .. '>' .. v .. '  '
            else
               tempstr = tempstr .. '  ' .. v .. '  '
            end
         end
         --]]
      end
      self:printDialogue(tempstr)
   end

end


function dialoguemanager.draw()

   dialoguemanager:render()

end


function dialoguemanager:update(dt)

end


function dialoguemanager:keypressed(key)

   dbug.show('dialogue key pressed: ' .. key)

   if key == ' ' then
      if self.boxes[1] then
         self.currbox = self.currbox + 1
         if not self.boxes[self.currbox] then
            dialoguemanager:endDialogue()
         end
      elseif self.menuitems[1] then
         self:endMenu()
      end
   end

   if (key == 'left') and self.menuitems[2] then
      self.curritem = self.curritem - 1
      dbug.show('current choice is ' .. self.curritem)
      if self.curritem <= 1 then self.curritem = 1 end
   end

   if (key == 'right') and self.menuitems[2] then
      self.curritem = self.curritem + 1
      dbug.show('current choice is ' .. self.curritem)
      if self.curritem >= #self.menuitems - 1 then self.curritem = #self.menuitems - 1 end
   end

end


return dialoguemanager
