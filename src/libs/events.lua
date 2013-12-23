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
         self:switchDialogue('octopus')
         self:getRope()
      else
         self:switchDialogue('octopus',{'That was not correct. Try again!'})
      end
   elseif menu == 'mermaid06' then
      if answer == 'Please' then
         self:switchDialogue('mermaid06')
         self:getCross()
      else
         self:switchDialogue('mermaid06',{'You have to be polite when you talk to ME!'})
      end
   end

end


function events:getHook()

   inventory:gain('hook')

   -- since i don't have combat implemented or a decent dialogue switcher
   self:switchDialogue('whale')

end


function events:getCross()

   inventory:gain('cross')

end


function events:getRope()

   inventory:gain('rope')

end

return events
