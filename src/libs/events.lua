local events = {}


function events:init()

   self.menus = {}
   self.menus.mermaid06 = { 'Well, do you want me to help you?', 'Yes', 'No', 'Please' }
   self.menus.octopus = { 'Well, how many tentacles do octopuses have?', '10','8','6','26' }


end


function events:switchDialogue(npc,t,map)

   local map = map or constants.currmap
   dbug.show(map)
   npcmanager.npcs[map][npc].dialogue.pre = t or npcmanager.npcs[map][npc].dialogue.post

end


function events:initMenu(menu)

   dbug.show('events starting menu ' .. menu)
   dialoguemanager:startMenu(menu, self.menus[menu])

end


function events:menuAnswer(menu, answer)

   dbug.show('menu: ' .. menu .. '  answer: ' .. answer)
   if menu == 'octopus' then
      if answer == '8' then
         self:switchDialogue('octopus',nil,'octoroom')
         self:getItem('rope')
      else
         self:switchDialogue('octopus',{'That was not correct. Try again!'},'octoroom')
      end
   elseif menu == 'mermaid06' then
      if answer == 'Please' then
         self:switchDialogue('mermaid06',nil,'anchorroom')
         self:getItem('cross')
      else
         self:switchDialogue('mermaid06',{'You have to be polite when you talk to ME!'},'anchorroom')
      end
   end

end


function events:getItem(item)

   inventory:gain(item)

   if item == 'hook' then
      -- since i don't have combat implemented or a decent dialogue switcher
      self:switchDialogue('whale',nil,'whaleroom')
   end

end


function events:checkAnchor()

   if not self.stopChecking then
      dbug.show('checking for anchor')
      if inventory:has('hook') and inventory:has('cross') and inventory:has('rope') then
         dbug.show('has all items')
         self:openMaze()
         self.stopChecking = true
      else
         dbug.show("doesn't have all items")
      end
   end

end


function events:openMaze()

   for _,v in ipairs({'buoy01','buoy02','buoy03','buoy04'}) do
      dbug.show('events is removing ' .. v)
      npcmanager:removeNPC('startroom',v)
   end
   self:switchDialogue('boat01',nil,'startroom')

end

return events
