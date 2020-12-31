game201227 = object
  // Elimination game. People vote one by one if something should work or not.
  // Later they vote who might be the Bad Guy in order to elimane that person.
  
  init = function(engine)
    players = preparePlayers("player", 4)
    winText = prepareWinText(engine)
  end
  
  preparePlayers = function(spriteType, amount)
    local players = []
    local badGuyIndex = random.nextInt(amount)+1
    
    for i = 1 to amount
      local name = spriteType+i
      local role = if i == badGuyIndex then "role_bad" else "role_good" end
      local player = prepareSingleElement(name, name, role)
      local x = (player.renderable.size.x * 2) * (i - amount/2)
      player.position.setTo(Vector2.make(x, 0))
      
      players.push(player)
    end
    
    return players
  end
  
  prepareSingleElement = function(spriteName, name, roleName)
    local element = engine.addGameObject(name)
    element.addSprite(spriteName)
    
    local onPress = function() 
      local go = this.gameObject
      local spriteName = go.renderable.image.name
      Fengine.getInstance().eventManager
        .triggerEvent(spriteName + "Touched", go)
    end
    element.addTouchableOnSprite(onPress)
    
    local leader = engine.addGameObject("leader")
    element.addChild(leader)
    leader.addSprite("leader").withAnchor(new Vector2(0, -1))
    leader.position.setTo(Vector2.make(0, element.renderable.size.y/2))
    leader.setEnabled(false)
    
    local role = engine.addGameObject("role")
    element.addChild(role)
    role.addSprite(roleName).withAnchor(new Vector2(0, -1))
    role.position.setTo(Vector2.make(0, element.renderable.size.y/2 + leader.renderable.size.y))
    role.setEnabled(false)
    
    local voteText = engine.addGameObject("voteText")
    element.addChild(voteText)
    voteText.addText("Vote!", 10, "white").withAnchor(new Vector2(0, 1))
    voteText.position.setTo(Vector2.make(0, -element.renderable.size.y/2))
    voteText.addTouchableOnText(function()
      local parent = this.gameObject.parent
      for child in parent.children
        if child.name == "role" then
          if child.renderable.image.name == "role_bad" then
            Fengine.getInstance().eventManager.triggerEvent("won", true)
          else
            parent.renderable.withAlpha(0.5)
          end
          child.setEnabled(true)
        end
      end
    end)
    
    return element
  end
  
  getRandomPosition = function()
    local x = random.nextInt(screen.width)
      - (screen.width/2)
      local y = random.nextInt(screen.height)
      - (screen.height/2)
      
    return new Vector2(x, y)
  end
  
  prepareWinText = function(engine)
    local text = engine.addGameObject("winText")
    text.addText("You win!", 30, "green")
    text.position.setTo(new Vector2(0, -40))
    text.setEnabled(false)
    engine.eventManager
      .addListener("won", "setEnabled", text)
    
    return text
  end
end