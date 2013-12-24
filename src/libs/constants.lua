local constants = {}


function constants:populate(x,w,h,animated,directioned,horiz,y)

   -- populate a table with quads for walking in all four directions
   -- bools --
   -- animated: make a 'b' table value for a two-frame character animation
   -- directioned: quads are laid out in a specific pattern for walking on the charsheet
   -- horiz: only relevant when directioned is false and animated is true
   --        frame b is horizontally to the right of frame a on the charsheet
   -- y is so i don't have to type 0 all the time

   local t = {}
   local y = y or 0

   if directioned then
      for i,v in ipairs(self.playerdirindex) do
         t[v] = {}
         t[v].a = love.graphics.newQuad(x,(i-1)*h,w,h,self.charsheet.w,self.charsheet.h)
         if animated then
            t[v].b = love.graphics.newQuad(x+w,(i-1)*h,w,h,self.charsheet.w,self.charsheet.h)
         end
         t[v].w = w
         t[v].h = h
      end
   else
      dbug.show('drawing non directioned')
      -- i tried not to do it this way, but alas
      for i,v in ipairs(self.playerdirindex) do
         t[v] = {}
         t[v].a = love.graphics.newQuad(x,y,w,h,self.charsheet.w,self.charsheet.h)
         if animated then
            t[v].b = love.graphics.newQuad(horiz and x+w or x, horiz and y or y+h,w,h,self.charsheet.w,self.charsheet.h)
            dbug.show('b frame is type ' .. type(t[v].b))
         end
         t[v].w = w
         t[v].h = h
      end
   end

   return t

end


function constants:loadSheet(imgfile)

   dbug.show('loadSheet loading ' .. imgfile)
   tbl = {}

   tbl.img = love.graphics.newImage('assets/' .. imgfile .. '.png')
   tbl.w = tbl.img:getWidth()
   tbl.h = tbl.img:getHeight()

   return tbl

end


function constants:newInvQuad(x,y)

   return love.graphics.newQuad(x,y,32,32,self.invsheet.w,self.invsheet.h)

end


function constants:newInvItem(x)

   t = {}
   t.a = constants:newInvQuad(x,0)
   t.b = constants:newInvQuad(x,32)
   return t

end

function constants:init()

   self.tilesize = 8

   self.w = love.graphics.getWidth()
   self.h = love.graphics.getHeight()
   self.wtile = 31
   self.htile = 30
   dbug.show(self.wtile)
   dbug.show(self.htile)

   self.playerdir = { up = { x = 0,
                             y = -1 },
                      down = { x = 0,
                               y = 1 },
                      left = { x = -1,
                               y = 0 },
                      right = { x = 1,
                                y = 0 }
                    }
   self.playerdirindex = {'down','right','up','left'}
   self.mapFile = 'map.txt'
   self.npcFile = 'npc.txt'

   -- where the player starts
   self.startingLoc = {}
   self.startingLoc.room = 'startroom'
   self.startingLoc.xtile = 20
   self.startingLoc.ytile = 15

   self.charsheet = self:loadSheet('charsheet')
   self.sprites = {}
   self.sprites.player = self:populate(0,16,16,true,true)
   self.sprites.cruiser = self:populate(32,24,16,true,true)
   self.sprites.tugboat = self:populate(80,24,16,true,true)
   self.sprites.whale = self:populate(128,32,16,true,false,false)
   self.sprites.mermaid = self:populate(128,8,24,true,false,true,32)
   self.sprites.seagull = self:populate(128,8,8,true,false,true,56)
   self.sprites.octopus = self:populate(144,16,16,true,false,false,32)
   self.sprites.dolphin = self:populate(160,16,16,true,true,false)
   self.sprites.rightsign = self:populate(192,16,16,true,false,true)
   self.sprites.leftsign = self:populate(192,16,16,true,false,true,16)
   self.sprites.buoy = self:populate(192,8,16,true,false,true,32)

   self.invsheet = self:loadSheet('inventory')
   self.inventory = {}
   self.inventory.hook = self:newInvItem(0)
   self.inventory.cross = self:newInvItem(32)
   self.inventory.rope = self:newInvItem(64)


   -- draw functions to pass to displaymanager
   -- simulates different 'gamestates'
   self.status = {}
   self.status.normal = {mapmanager.draw,
                         displaymanager.drawSprites,
                         inventory.draw,
                         playermanager.draw,
                         collisionmanager.draw}
   self.status.dialogue = {mapmanager.draw,
                           displaymanager.drawSprites,
                           inventory.draw,
                           dialoguemanager.draw}

   dbug.show('constants loaded')

end


-- functions used by multiple modules

function constants.clearTable(tbl)

   for k,_ in pairs(tbl) do
      tbl[k] = nil
   end

end


function constants:pxtotile(n)

   return math.floor(n / self.tilesize)

end


function constants:tiletopx(n)

   return n * self.tilesize

end

return constants
