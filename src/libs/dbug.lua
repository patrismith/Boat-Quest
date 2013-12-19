dbug = {}

function dbug.show(msg)
   -- if debugging is on, print msg to the console
   if dbugglobal then
      print(msg)
   end

end

return dbug
