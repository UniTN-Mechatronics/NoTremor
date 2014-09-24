PBVertLine = class()
--[[
colors = {
    color(255, 0, 232, 255),
    color(255, 9, 0, 255),
    color(197, 255, 0, 255),
    color(0, 135, 255, 255),
    color(0, 255, 145, 255),
    color(255, 165, 0, 255)
}

  ]]
colors = {
    color(255, 0, 38, 255),
}
function PBVertLine:init(master)
    -- you can accept and set parameters here
    self.master = master
    self.tween = nil
    self:reset()
end

function PBVertLine:reset()
    self.x=math.random(0, WIDTH)
    self.animating = false
    self.color = colors[math.random(1, #colors)]
    tween.reset(self.tween)
end

function PBVertLine:draw()
    -- Codea does not automatically call this method
    if self.animating == false then
        self.tween = tween(poisson(self.master.avgDelay), self, {}, tween.easing.linear, function() self:reset(); sound("Game Sounds One:Block 1") end)
    end
    self.animating = true
    pushStyle()
    stroke(self.color)
    strokeWidth(3)
    line(self.x, 0, self.x, HEIGHT)
    popStyle()
end

function PBVertLine:touched(touch)
    -- Codea does not automatically call this method
end
