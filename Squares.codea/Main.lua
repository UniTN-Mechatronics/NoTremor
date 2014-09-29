-- test

-- Use this function to perform your initial setup
function setup()
    displayMode(OVERLAY)
    supportedOrientations(LANDSCAPE_ANY)
    path = PBPath(WIDTH/2, HEIGHT/2)
    buttonStart = PBButton("Start test")
    path.avgDelay = readLocalData("avgDelay", 5)
    path.minDelay = readLocalData("minDelay", 1) 
    path.p = vec2(WIDTH/2, HEIGHT/2)
    buttonStart.pos.x = WIDTH - 90
    buttonStart.pos.y = 40
    hideNavbar = false

    size = readLocalData("size", 60)
    steps = readLocalData("steps", 10)
    disturbingLines = readLocalData("disturbingLines", 3)
    animateBackground = readLocalData("animateBackground", false)
    recordVideo = readLocalData("recordVideo", false)
    subject = readLocalData("subject", "Unknown")
    camera = readLocalData("camera", false)
    cameraPos = readLocalData("cameraPos", 0)
    camOnTop = readLocalData("camOnTop", true)
    animatePressure = readLocalData("animatePressure", false)

    parameter.text("subject", subject, function() saveLocalData("subject", subject) end)
    parameter.action("reset count", function() saveLocalData("runid", 0) end)
    parameter.integer("disturbingLines", 0, 10, disturbingLines, function() saveLocalData("disturbingLines", disturbingLines) end)
    parameter.integer("steps", 1, 50, steps, function() saveLocalData("steps", steps) end)
    parameter.number("avgDelay", 0, 5, path.avgDelay, function() avgDelay = round(avgDelay, 1); path.avgDelay = avgDelay; saveLocalData("avgDelay", avgDelay) end)
    parameter.number("minDelay", 0, 5, path.minDelay, function() minDelay = round(minDelay, 1); path.minDelay = minDelay; saveLocalData("minDelay", minDelay) end)
    parameter.integer("size", 0, 100, size, function() path.size = size; saveLocalData("size", size) end)
    parameter.boolean("animateBackground", animateBackground, function() saveLocalData("animateBackground", animateBackground) end)
    parameter.boolean("recordVideo", recordVideo, function() saveLocalData("recordVideo", recordVideo) end)
    parameter.boolean("camera", camera, function() saveLocalData("camera", camera) end)
    parameter.integer("cameraPos", 0, HEIGHT, cameraPos, function() saveLocalData("cameraPos",  cameraPos) end)
    parameter.boolean("camOnTop", camOnTop, function() saveLocalData("camOnTop", camOnTop) end)
    parameter.boolean("hideNavbar", false)
    parameter.boolean("animatePressure", animatePressure, function() saveLocalData("animatePressure", animatePressure) end)

    buttonStart.action = startStop
    touches = {}
    states = {}
    createDisturbingLines()
    if STYLUS_ADDON then
        print("Lua StylusAddon available")
    else
        stylusPressure = function() return CurrentTouch.y; end
        normalizedStylusPressure = function() return CurrentTouch.y / HEIGHT; end
        isStylusConnected = function() return true; end
    end
    buttonStart.graphic = STYLUS_ADDON
end

function round(num, idp)
    local mult = 10^(idp or 0)
    return math.floor(num * mult) / mult
end

function startStop(start)
    if start then
        path:makePath(steps)
        buttonStart.displayName = "MX:stop"
        createDisturbingLines()
    else
        path:endAnimation()
        buttonStart.displayName = "MX:start"
    end
end

function createDisturbingLines()
    disturbingLinesTab = {}
    local l
    for i = 1, disturbingLines do
        l = PBVertLine(path)
        table.insert(disturbingLinesTab, l)
    end
end


function drawCamera(active)
    if camera and active then
        cameraSource(CAMERA_FRONT)
        sprite(CAMERA, WIDTH/2, HEIGHT/2+cameraPos, WIDTH)
    end
end

-- This function gets called once every frame
function draw()
    -- This sets a dark background color 
    if animateBackground then
        background(path.r, path.g, 50)
        else
        background(200)
    end
    
    drawCamera(not camOnTop)

    if path.animating then
        for i,l in ipairs(disturbingLinesTab) do
            l:draw()
        end
    else
        buttonStart.displayName = "MX:start"
    end
       
    path:draw()
    drawCamera(camOnTop)

    pushStyle()
    fill(0)
    font("Courier")
    textMode(CORNER)
    text(string.format("%s @ %s", subject, os.date()), 10, HEIGHT-20)
    textAlign(RIGHT)
    font("Courier-Bold")
    fontSize(18)
    fill(0, 0, 0, 255)
    if isStylusConnected() then
        text(string.format("p: %4d/%1.3f n: %d", stylusPressure(), normalizedStylusPressure(), #path.path), WIDTH-120, HEIGHT-20)
    else
        text(string.format("n: %d", #path.path), WIDTH-60, HEIGHT-20)
    end
    popStyle()

    pushMatrix()
    pushStyle()
    strokeWidth(2)
    stroke(0)
    noFill()
    rectMode(CENTER)
    text("test", WIDTH/2, HEIGHT/2)
    local s = (10 + (math.min(WIDTH, HEIGHT) - 10) * normalizedStylusPressure()^0.5)
    rect(WIDTH/2, HEIGHT/2, s, s)
    popStyle()
    popMatrix()
    
    buttonStart:draw()
end

function touched(touch)
    buttonStart:touched(touch, not path.animating)
    path:touched(touch)
end

function poisson(lambda, cut)
    cut = cut or 0
    local L, k, p
    L = math.exp(-lambda)
    repeat
        k = 0
        p = 1
        repeat
            k = k + 1
            p = p * math.random()
        until p <= L
    until k - 1 >= cut
    return k - 1
end



