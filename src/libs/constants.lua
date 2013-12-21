local constants = {}


function constants:populate(x,w,h)

   -- populate a table with quads for walking in all four directions

   local t = {}

   for i,v in ipairs(self.playerdirindex) do
      t[v] = {}
      t[v].a = love.graphics.newQuad(x,(i-1)*h,w,h,self.charsheet.w,self.charsheet.h)
      t[v].b = love.graphics.newQuad(x+w,(i-1)*h,w,h,self.charsheet.w,self.charsheet.h)
   end

   return t

end


function constants:init()

   self.tilesize = 8
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
   self.mapFile = 'testmap.txt'
   self.npcFile = 'testnpc.txt'

   -- where the player starts
   self.startingLoc = {}
   self.startingLoc.room = 'testroom'
   self.startingLoc.xtile = 20
   self.startingLoc.ytile = 15

   self.charsheet = {}
   self.charsheet.img = love.graphics.newImage('assets/charsheet.png')
   self.charsheet.w = self.charsheet.img:getWidth()
   self.charsheet.h = self.charsheet.img:getHeight()
   self.sprites = {}
   self.sprites.player = self:populate(0,16,16)
   self.sprites.cruiser = self:populate(32,24,16)
   self.sprites.tugboat = {}

   -- draw functions to pass to displaymanager
   -- simulates different 'gamestates'
   self.status = {}
   self.status.normal = {mapmanager.draw,
                         displaymanager.drawSprites,
                         playermanager.draw,
                         collisionmanager.draw}
   self.status.dialogue = {mapmanager.draw,
                           displaymanager.drawSprites,
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
