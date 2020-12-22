initGameFingerprint = function(engine)
  won = false
  screenBounds = engine.getScreenBounds()
  
  items = []
  local baseX = 0
  for i = 1 to 3
    baseX += item.renderable.size.x*2
    local name = "item" + i
    local item = engine.addGameObject(name)
    item.addSprite(name)
    item.position.setTo(Vector2.make(baseX, 0))
    
    items.push(item)
  end
  
  fingerprint = engine.addGameObject("fingerprint")
  fingerprint.addSprite("fingerprint").withAlpha(0.1)
  fingerprint.addTouchableOnSprite(function() global.won = true end)
  
  local itemIndex = random.nextInt(items.length)
  items[itemIndex].addChild(fingerprint)
  
  winText = prepareWinText()
end

prepareWinText = function()
  local text = engine.addGameObject("winText")
  text.addText("You win!", 30, "grey", "VeniceClassic")
  text.enabled = false
  text.enableChangeAction = function()
    if global.won then
      winText.enabled = true
    end
  end
  
  return text
end