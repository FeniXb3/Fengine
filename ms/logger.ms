Logger = class
  logError = function(text)
    print("[FENGINE ERROR] " + text)
  end
  
  // TODO: Add possibility to limit amount of messages from a specific source
  logInfo = function(text)
    print("[INFO] " + text)
  end
end