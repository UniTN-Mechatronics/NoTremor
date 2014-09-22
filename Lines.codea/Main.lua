-- test

-- Use this function to perform your initial setup
function setup()
    -- displayMode(FULLSCREEN)
    supportedOrientations(LANDSCAPE_ANY)
    path = PBPath(WIDTH/2, HEIGHT/2)
    buttonStart = PBButton("Start test")
    path.avgDelay = readLocalData("avgDelay", 5)
    path.minDelay = readLocalData("minDelay", 1) 
    path.p = vec2(WIDTH/2, HEIGHT/2)
    buttonStart.pos.x = 75
    buttonStart.pos.y = 75
    size = readLocalData("size", 20)
    steps = readLocalData("steps", 2) 
    nLines = readLocalData("nLines", 2)
    animateBackground = readLocalData("animateBackground", false)
    recordVideo = readLocalData("recordVideo", false)
    subject = readLocalData("subject", "Unknown")
    camera = readLocalData("camera", false)
    parameter.text("subject", subject, function() saveLocalData("subject", subject) end)
    parameter.action("reset count", function() saveLocalData("runid", 0) end)
    parameter.integer("nLines", 0, 10, nLines, disturbingLines)
    parameter.integer("steps", 1, 50, steps, function() saveLocalData("steps", steps) end)
    parameter.integer("avgDelay", 0, 20, path.avgDelay, function() path.avgDelay = avgDelay; saveLocalData("avgDelay", avgDelay) end)
    parameter.integer("minDelay", 0, 20, path.minDelay, function() path.minDelay = minDelay; saveLocalData("minDelay", minDelay) end)
    parameter.integer("size", 0, 100, size, function() path.size = size; saveLocalData("size", size) end)
    parameter.boolean("animateBackground", animateBackground, function() saveLocalData("animateBackground", animateBackground) end)
    parameter.boolean("recordVideo", recordVideo, function() saveLocalData("recordVideo", recordVideo) end)
    parameter.boolean("camera", camera, function() saveLocalData("camera", camera) end)
    buttonStart.action = startStop
    touches = {}
    states = {}
    disturbingLines()
    if STYLUS_ADDON then
        print("Lua StylusAddon available")
    end
end

function startStop(start)
    if start then
        path:makePath(steps)
        buttonStart.displayName = "Stop"
    else
        path:endAnimation()
        buttonStart.displayName = "Start test"
        disturbingLines() -- reenable tweens
    end
end

function disturbingLines()
    saveLocalData("nLines", nLines)
    disturbingLinesTab = {}
    local l
    for i = 1, nLines do
        l = PBVertLine(path)
        table.insert(disturbingLinesTab, l)
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
    if camera then
        cameraSource(CAMERA_FRONT)
        sprite(CAMERA, WIDTH/2, HEIGHT/2, WIDTH)
    end

    if path.animating then
        for i,l in ipairs(disturbingLinesTab) do
            l:draw()
        end
    else
        buttonStart.displayName = "Start test"
    end
    buttonStart:draw()
    path:draw()
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
