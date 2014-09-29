PBPath = class()

function PBPath:init(x, y)
    -- you can accept and set parameters here
    self.p = vec2(x, y)
    self.t = vec2(x, y)
    self.size = 20
    self.lapse = -1
    self.r = 0 
    self.g = 0
    self.path = {}
    self.tweens = {}
    self.touches = {}
    self.minDelay = 0
    self.avgDelay = 5
    self.rotation = 0
    self.animating = false
    self.moving = false
    self.file = ""
    self.current = {i=0, prev=0, epoch=ElapsedTime, startPos=0}
    self.steps = 0
    self.dataBuffer = {}
end

function PBPath:check()
    local str = string.format("Check %d,%d", self.p.x, self.p.y)
    print(str)
end

function PBPath:header(n)
    local desc = "# Lines test number "..(readLocalData("runid", 0) + 1)
    desc = desc.."\n# date: "..os.date()
    desc = desc.."\n# steps: "..self.steps
    desc = desc.."\n# min delay (s): "..self.minDelay
    desc = desc.."\n# max delay: (s)"..self.avgDelay
    desc = desc.."\n# disturbing lines: "..disturbingLines
    desc = desc.."\n# subject name: "..subject.."\n"
    for i, v in ipairs(self.path) do
        desc = desc..string.format("# p=%f t=%f\n", v.x, v.dt)
    end
    desc = desc.."t t_rel n x y px x_rel touch_state lapse ax ay az pressure\n"
    return desc
end

function PBPath:draw()
    -- Codea does not automatically call this method
    local red = color(243, 12, 40, 255)
    local green = color(65, 189, 45, 255)
    
    pushStyle()
    strokeWidth(5)
    pushMatrix()
    if CurrentTouch.state == ENDED then
        self.t = {x=WIDTH/2, y=HEIGHT/2}
    end
    translate(self.t.x, self.t.y)

    pushMatrix()
    if self.animating then
        popMatrix()
        popMatrix()
        strokeWidth(4)
        stroke(13, 0, 255, 255)
        if #self.path > 0 then
            local p, ti, dx
            if self.lapse <= 1 and self.current.prev > 1 then
                self.current.i = self.current.i + 1
                self.current.epoch = ElapsedTime
            end
            p = self.path[1]
            line(p.x, 0, p.x, HEIGHT)
            ti = ElapsedTime - self.current.epoch - 1
            self.current.prev = self.lapse
            dx = math.abs(self.t.x - self.current.startPos) / math.abs(self.path[1].x - self.current.startPos)
        table.insert(self.dataBuffer, {ElapsedTime, ti, self.current.i, self.t.x, self.t.y, p.x, dx, CurrentTouch.state, self.lapse, UserAcceleration.x, UserAcceleration.y, UserAcceleration.z, stylusPressure()})
        end
    else
        popMatrix()
        popMatrix()
    end
    popStyle()
    
    self.r = (self.t.x / WIDTH) * 256
    self.g = (self.t.y / HEIGHT) * 256
    
end

function PBPath:touched(touch)
    if touch.state ==  BEGAN then
        table.insert(self.touches, touch.id)
    elseif touch.state == ENDED then
        table.remove(self.touches)
    end
    -- Codea does not automatically call this method
    if (touch.state == MOVING or touch.state == BEGAN) and touch.id == self.touches[1] then
        self.t.x = touch.x
        self.t.y = touch.y
    end
end

function PBPath:describe()
    for i, v in ipairs(self.path) do
        print((v.x/WIDTH).." "..(v.y/HEIGHT))
    end        
end

function PBPath:endAnimation()
    if self.animating then
        if isRecording() then
            stopRecording()
        end
        tween.stopAll()
        self.animating = false
        self.lapse = -1
        self.rotation = 0
        self.path = {}
        self.file = self:fname()
        io.output(io.open(self.file, "w"))
        io.write(self:header(n, degree))
        for i, l in ipairs(self.dataBuffer) do
            io.write(table.concat(l, " ").."\n")
        end
        io.close()
        self.dataBuffer = {}
        saveLocalData("runid", self.runid + 1)
        print("Saved file "..self.file)
        hideNavbar = false
    end
end

function PBPath:makePath(n)
    displayMode(FULLSCREEN)
    hideNavbar = true
    if recordVideo then
        startRecording()
    end
    self.steps = n
    self.path = {}
    -- tween.resetAll()
    local rx, t, dt, dn1, dx
    local prevx = WIDTH/2
    for i = 1, n do
        dt = self:rand()
        repeat
            rx = math.random(10, WIDTH-10)
            dx = math.abs(rx - prevx)
        until dx <= WIDTH * 0.7 and dx >= WIDTH * 0.3
        prevx = rx
        table.insert(self.path, {x=rx, dt=dt})
    end
    self.tweens = {tween(2, self, {rotation=45, lapse=self.path[1].dt}, tween.easing.quadIn)}
    self.current.startPos = self.path[1].x
    for i = 1, n do
        if i < n then
            dt = self.path[i].dt
            dt1 = self.path[i+1].dt
            t = tween(dt, self, {lapse=0}, tween.easing.linear, function(dt) sound("Game Sounds One:Block 2"); self.lapse = dt; self.current.startPos = self.path[1].x; table.remove(self.path, 1) end, dt1)
        else 
            t = tween.delay(3, function() self:endAnimation() end)
        end
        table.insert(self.tweens, t )
    end
    self.animating = true
    tween.sequence(unpack(self.tweens))
    --self:describe()
end

function PBPath:fname()
    self.runid = readLocalData("runid", 0)
    if STYLUS_ADDON then
        return os.getenv("HOME").."/Documents/log_lines_"..self.runid..".txt"
    else
        return os.getenv("HOME").."/Documents/Dropbox.assets/log_lines_"..self.runid..".txt"
    end
end

function PBPath:rand()
    --return self.minDelay + math.random() * (self.avgDelay - self.minDelay)
    return (poisson(self.avgDelay*10.0, self.minDelay*10.0))/10.0
end



