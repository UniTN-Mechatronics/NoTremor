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

    size = readLocalData("size", 20)
    steps = readLocalData("steps", 2) 
    nLines = readLocalData("nLines", 2)
    animateBackground = readLocalData("animateBackground", false)
    recordVideo = readLocalData("recordVideo", false)
    subject = readLocalData("subject", "Unknown")
    camera = readLocalData("camera", false)
    cameraPos = readLocalData("cameraPos", 0)
    camOnTop = readLocalData("camOnTop", true)

    parameter.text("subject", subject, function() saveLocalData("subject", subject) end)
    parameter.action("reset count", function() saveLocalData("runid", 0) end)
    parameter.integer("nLines", 0, 10, nLines, disturbingLines)
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

    buttonStart.action = startStop
    touches = {}
    states = {}
    disturbingLines()
    if STYLUS_ADDON then
        print("Lua StylusAddon available")
    else
        stylusPressure = function() return 0; end
        normalizedStylusPressure = function() return 0; end
        isStylusConnected = function() return false; end
    end
    buttonStart.graphic = true
end

function round(num, idp)
    local mult = 10^(idp or 0)
    return math.floor(num * mult) / mult
end

function startStop(start)
    if start then
        path:makePath(steps)
        buttonStart.displayName = "MX:stop"
    else
        path:endAnimation()
        buttonStart.displayName = "MS:start"
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


function drawCamera(active)
    if camera and active then
        cameraSource(CAMERA_FRONT)
        sprite(CAMERA, WIDTH/2, HEIGHT/2+cameraPos, WIDTH)
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
            text(string.format("p: %4d/%1.3f n: %d", stylusPressure(), normalizedStylusPressure(), #path.path), WIDTH-110, HEIGHT-20)
            else
            text(string.format("n: %d", #path.path), WIDTH-50, HEIGHT-20)
        end

        popStyle()
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


