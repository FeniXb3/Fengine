Animator = class extends Drawable
  constructor = function(name)
    this.currentClip = sprites[name]
    this.size = new Vector2(this.currentClip.width, this.currentClip.height)
    this.name = name
    this.clips = object 
      animator = this
      "__default__" = this.currentClip
    end

    super()
  end

  addClip = function(clipName, )
    clips[clipName] = sprites[name+"_"+clipName]

    return this
  end

  play = function(clipName, repeatitionCount=-1, afterAction)
    this.currentClip = clips[clipName]
    this.size = new Vector2(this.currentClip.width, this.currentClip.height)
    reset()
    this.maxRepeatitionCount = repeatitionCount
    this.afterAction = afterAction

    return this
  end
  
  playDefault = function(repeatitionCount=-1, afterAction)
    play("__default__", repeatitionCount, afterAction)
    return this
  end

  reset = function()
    this.lastFrameTime = system.time()
    this.isPlaying = true
    this.repetitionNumber = 0
    this.lastFrameIndex = currentClip.frames.length-1
    this.currentFrameIndex = 0
    this.animationFinished = false
  end

  pause = function()
    isPlaying = false
  end

  resume = function()
    isPlaying = true
  end

  draw = function(position, translation)
    if animationFinished and isPlaying then
      isPlaying = false
      afterAction()
    elsif isPlaying and system.time() - lastFrameTime > (1000 / currentClip.fps) then
      lastFrameTime = system.time()
      if currentFrameIndex == lastFrameIndex and not animationFinished then
        repetitionNumber += 1
        if maxRepeatitionCount != -1 and repetitionNumber >= maxRepeatitionCount then
          animationFinished = true
        else
          currentFrameIndex = 0
        end
      elsif not animationFinished then
        currentFrameIndex += 1
      end
    end

    local frame = currentClip.name+"."+currentFrameIndex
    screen.drawSprite(frame, position.x, position.y, size.x, size.y)
  end
end