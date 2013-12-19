local constants = {}


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
   self.playerdirindex = {'up','down','left','right'}
   self.mapFile = 'testload.txt'
   self.npcFile = 'testnpc.txt'

   -- where the player starts
   self.startingLoc = {}
   self.startingLoc.room = 'YourOffice'
   self.startingLoc.xtile = 20
   self.startingLoc.ytile = 15

   self.charsheet = love.graphics.newImage('assets/sprites.png')
   self.sprites = {}
   self.sprites.player = love.graphics.newQuad(0,0,8,8*2,8*8,8*2)
   self.sprites.pigtails = love.graphics.newQuad(8*3,0,8,8*2,8*8,8*2)
   self.sprites.notsure = love.graphics.newQuad(8*2,0,8,8*2,8*8,8*2)

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
