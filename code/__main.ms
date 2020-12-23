init = function()
  engine =  Fengine.getInstance()
  gameFingerprint.init(engine)
end

update = function()
  engine.update()
end

draw = function()
  engine.draw()  
end