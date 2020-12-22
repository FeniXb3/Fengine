init = function()
  engine =  Fengine.getInstance()
  initGameFingerprint(engine)
end

update = function()
  engine.update()
end

draw = function()
  engine.draw()  
end

