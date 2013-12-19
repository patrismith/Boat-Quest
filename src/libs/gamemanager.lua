local gamemanager = {}


function gamemanager:init()

   constants:init()
   collisionmanager:init()
   dialoguemanager:init()
   displaymanager:init()
   mapmanager:init()

   -- start the player
   playermanager:init(constants.startingLoc.xtile,constants.startingLoc.ytile)

   self:setState('normal')

end


function gamemanager:setState(str)

   -- for now, i'm going to use gamemanager.status to denote game state
   -- 'normal' is walking around on a game map
   -- 'dialogue' is when a dialogue box must be read, and other game events are frozen
   -- the dialogue manager is going to change this variable directly when it needs to
   self.status = str
   displaymanager:clearDrawFuncs()
   displaymanager:addDrawFuncs(constants.status[self.status])

end


function gamemanager:update(dt)

   -- i may want to change this to a 'function list' like the displaymanager uses

   if self.status == 'normal' then
      playermanager:update(dt)
      npcmanager:update(dt)
   elseif self.status == 'dialogue' then
      dialoguemanager:update(dt)
   end

end


function gamemanager:keypressed(key)

   if self.status == 'normal' then
      playermanager:keypressed(key)
   elseif self.status == 'dialogue' then
      dialoguemanager:keypressed(key)
   end

end

return gamemanager
