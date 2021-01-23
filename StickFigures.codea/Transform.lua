Transform = class()

function Transform:init(opt)
    opt = opt or {}
    self.name = opt.name or 'Transform'
    self.pos = opt.pos
    self.rot = opt.rot or 0
    self.scale = opt.scale or vec2(1, 1)
    self.parent = opt.parent or nil
    if self.pos == nil then
        if self.parent == nil then
            self.pos = vec2(WIDTH / 2, HEIGHT / 2)
        else
            self.pos = vec2(0,0)
        end
    end
    self.mode = opt.mode or CENTER
    self.mtx = Transform.GetGlobalCTM(self)
    self.globalPos = vec2(0,  0)
    self.globalRot = 0
    self.globalScale = vec2(1,1)
    self.forward = vec2(self.mtx[1], self.mtx[2]):normalize()
end
-- Matrix Calcuation Helpers
function Transform.GetGlobalPos(transform)
    local gPos = vec2(transform.pos:unpack())
    
    if transform.parent then
        gPos = gPos + Transform.GetGlobalPos(transform.parent)
    end
    
    return gPos
end

function Transform.GetGlobalRot(transform)
    local gRot = transform.rot ~= 0 and transform.rot or 1
    
    if transform.parent then
        gRot = Transform.GetGlobalRot(transform.parent) * gRot
    end
    
    return gRot
end

function Transform.GetGlobalScale(transform)
    local scl = vec2(transform.scale:unpack())
    
    if transform.parent then
        scl = Transform.GetGlobalRot(transform.parent) * scl
    end
    
    return scl
end



function Transform.GetGlobalCTM(transform)
    local pos = transform.pos
    local rot = transform.rot
    local scl = transform.scale
    local m = matrix()
    m = m:translate(pos.x, pos.y, 0)
    m = m:rotate(rot, 0, 0, 1)
    m = m:scale(scl.x, scl.y, 1)
    if transform.parent then
        return m * Transform.GetGlobalCTM(transform.parent)
    end
    return m
end

function Transform.PosToScreenPos(transform)
    local gm = transform.mtx or Transform.GetGlobalCTM(transform)
    local sctm = gm * viewMatrix() -- * projectionMatrix()
    return vec2(sctm[13], sctm[14])
end

function applyTransform(v, m)
    -- tY
    m[14] = v.y
    -- -- tX
    m[13] = v.x
    -- m = m:translate(v.x, v.y)
    return --m:translate(v.x, v.y, 1)
end

function applyRotation(rot, m)
    local angle = rot * mathX.deg2rad
    m[1] = math.cos(angle)
    m[2] = -math.sin(angle)
    m[5] = math.sin(angle)
    m[6] = math.cos(angle)
    return m
end
-- getters
function Transform:boundingBox()
    local x,y = Transform.PosToScreenPos(self):unpack()
    --self.globalPos:unpack()
    local w, h = 75, 75 -- dummy size for base transform
    
    if self.mode == CENTER then
        x = x - (w / 2)
        y = y - (h / 2)
        --w = w - w / 2
    end
    
    return {x = x, y = y, w = w * self.scale.x, h = h * self.scale.y}
end

function Transform:inBounds(t)
    local bbox = self:boundingBox()
    local x2 = bbox.x + bbox.w
    local y2 = bbox.y + bbox.h
    return t.pos.x >= bbox.x and t.pos.x <= x2 and t.pos.y >= bbox.y and t.pos.y <= y2
end
--
function Transform:update()
    local didUpdate = false
    local wPos = Transform.GetGlobalPos(self)
    local gRot = Transform.GetGlobalRot(self)
    local gScl = Transform.GetGlobalScale(self)

    self.lastPos = self.lastPos or nil
    self.lastRot = self.lastRot or nil
    self.lastScale = self.lastScale or nil
    self.globalPos = vec2(wPos:unpack())
    self.globalRot = gRot
    self.globalScale = gScl
    -- is Pos dirty
    local isDirty = self.lastPos == nil or self.lastPos.x ~= wPos.x or self.lastPos.y ~= wPos.y
    isDirty = isDirty or self.lastRot == nil or self.lastRot ~= gRot
    
    isDirty = isDirty or self.lastScale == nil or self.lastScale.x ~= gScl.x or self.lastScale.y ~= gScl.y
    if isDirty then
        self.mtx = Transform.GetGlobalCTM(self)
        self.forward = vec2(self.mtx[1], self.mtx[2]):normalize()
        self.lastPos = vec2(wPos:unpack())
        self.lastRot = gRot
        self.lastScale = vec2(gScl:unpack())
        didUpdate = true
    end
    return didUpdate
end

function Transform:draw()
    self:update()
    if self.onDraw then
        pushMatrix() pushStyle()
        resetMatrix()
        modelMatrix(self.mtx)
        self.onDraw(self)
        popMatrix() popStyle()
    end
    --[[
    pushMatrix() pushStyle()
    resetMatrix()
    modelMatrix(self.mtx)
    rectMode(self.mode)
    textMode(self.mode)
    local b = self:boundingBox()
    local x2 = b.x + b.w
    local y2 = b.y + b.h
    fill(242, 89, 43)
    rect(0,0, b.w, b.h)
    fill(104, 233, 80)
    ellipse(b.w/2, b.h/2, 10)
    fill(214)
    fontSize(12)
    textWrapWidth(50)
    text(
    'x: ' .. b.x .. ', y: ' .. b.y .. ', xw: ' .. x2 .. ', yh:' .. y2,
    0,
    0
    )
    pushMatrix()
    resetMatrix()
    strokeWidth(5)
    stroke(191, 233, 80)
    noFill()
    line(b.x, b.y, x2, y2)
    popMatrix()
    popMatrix() popStyle()
    --]]
end

function Transform:touched(touch)
    if touch and touch.state == BEGAN then
        if _editor then
            _editor:select(self)
        end
    end
end
