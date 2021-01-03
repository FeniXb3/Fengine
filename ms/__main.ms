init = function()
  engine =  Fengine.getInstance()
  game210102.init(engine)
end

update = function()
  engine.update()
  
  local pos1 = game210102.boat1.position
  local pos2 = game210102.boat2.position
  local pos3 = game210102.boat3.position
  local pos4 = game210102.boat4.position
  
  if (pos1.getDistanceTo(pos2)
  +pos1.getDistanceTo(pos3)
  +pos1.getDistanceTo(pos4)) == 0 then
    engine.eventManager.triggerEvent("won", true)
  end
end

draw = function()
  engine.draw()  
end