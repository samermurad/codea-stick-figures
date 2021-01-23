Transform2D = class()

local rotMTX = {
--      angle,         angle
        math.cos(0), - math.sin(0), 0,
--      angle,       angle
        math.sin(0), math.cos(0), 0,
        0 , 0, 1
}

local transMTX = {
--            tX
    1, 0, 0,  0,
--            tY
    0, 1, 0 , 0,
--          tW
    0, 0, 1, 0,
    --          tW  ?
    0, 0, 0, 1,
}

local scaleMTX = {
--  sX
    0, 0 , 0,
--  -  sY
    0, 0,  0,
    0, 0, 1
}

local generalAffineTransMTX = {
--  a11, a12, a13
    0,   0,   0,
--  a21, a22, a23
    0,   0,   0,
    
    0,   0, 1
}
function Transform2D:init(opt)
    -- you can accept and set parameters here
    opt = opt or {}
    self.pos = opt.pos or vec3(0, 0, 1)
    self.mtx = modelMatrix()
    print(self.mtx)
end

function Transform2D:update()
    -- tY
    self.mtx[14] = HEIGHT / 2
    -- tX
    self.mtx[13] = WIDTH / 9
    -- scaleX
    self.mtx[1] = 0.4
    -- scaleY
    self.mtx[6] = 1.4
end

function Transform2D:draw()
    self:update()
    pushMatrix()
    resetMatrix()
    modelMatrix(self.mtx)
    fill(255, 0, 0)
    ellipse(0, 0, 25)
    line(0,0 ,65, 0)
    popMatrix()
end

function Transform2D:touched(touch)
    -- Codea does not automatically call this method
end
