ATL = require('Advanced-Tiled-Loader')

gamemanager = require('libs.gamemanager')
constants = require('libs.constants')
collisionmanager = require('libs.collisionmanager')
dialoguemanager = require('libs.dialoguemanager')
mapmanager = require('libs.mapmanager')
npcmanager = require('libs.npcmanager')
displaymanager = require('libs.displaymanager')
playermanager = require('libs.playermanager')
events = require('libs.events')
inventory = require('libs.inventory')
dbug = require('libs.dbug')

dbugglobal = true

function love.load()

   -- general graphical stuff
   ATL.Loader.path = 'assets/maps/'

   love.graphics.setColorMode('replace')
   love.graphics.setLine(1,'rough')



   local img = love.graphics.newImage('assets/littlefont.png')
   img:setFilter("nearest","nearest")
   dialogueFont = love.graphics.newImageFont(img, " ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789.,!'\"-:?>")
   dialoguebg = love.graphics.newImage('assets/dialogue.png')
   dialoguebg:setFilter("nearest","nearest")
   inventorybg = love.graphics.newImage('assets/inventory.png')

   love.graphics.setFont(dialogueFont)

   -- start the game
   gamemanager:init()

end


function love.update(dt)

   gamemanager:update(dt)

end


function love.draw()

   displaymanager:draw()

end


function love.keypressed(key)

   if key == '`' then
      dbugglobal = not dbugglobal
   else
      gamemanager:keypressed(key)
   end

end
