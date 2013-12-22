local dialoguemanager = {}


function dialoguemanager:init()

   self.boxes = {}
   self.currbox = 1

end


function dialoguemanager:addBox(tbl)

   for i,phrase in ipairs(tbl) do
      dbug.show('adding ' .. phrase .. ' to dialogue')
      table.insert(self.boxes, phrase)
   end

end


function dialoguemanager:clearAll()

   constants.clearTable(self.boxes)
   self.currbox = 1

end


function dialoguemanager:startDialogue(tbl)

   if tbl then
      dialoguemanager:addBox(tbl)
      self.currbox = 1
      gamemanager:setState('dialogue')
   end

end


function dialoguemanager:endDialogue()

   gamemanager:setState('normal')
   dialoguemanager:clearAll()

end


function dialoguemanager:box(x,y,w,h)

   love.graphics.setColor(0,0,0)
   love.graphics.rectangle("fill",x,y,w,h)
   love.graphics.setColor(255,255,255)
   love.graphics.rectangle("fill",x+2,y+2,w-4,h-4)
   love.graphics.setColor(0,0,0)
   love.graphics.rectangle("fill",x+4,y+4,w-8,h-8)
   love.graphics.setColor(255,255,255)

end


function dialoguemanager:render()

   self:box(0,21*8,31*8,8*8)
   love.graphics.printf(self.boxes[self.currbox],11,21*8+11,31*8-23,"left")

end


function dialoguemanager.draw()

   dialoguemanager:render()

end


function dialoguemanager:update(dt)

end


function dialoguemanager:keypressed(key)

   if key == ' ' then
      self.currbox = self.currbox + 1
      if not self.boxes[self.currbox] then
         dialoguemanager:endDialogue()
      end
   end

end


return dialoguemanager
