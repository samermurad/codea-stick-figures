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
    self.mtx = Transform.CTM(self)
    self.globalPos = vec2(0,  0)
    self.globalRot = 0
    self.globalScale = vec2(self.mtx[1], self.mtx[6])
    self.forward = vec2(self.mtx[1], self.mtx[2]):normalize()
    self.layout = 0
    self.didUpdate = true
end
-- Matrix Calcuation Helpers
function Transform.CTM(transform)
    local pos = transform.pos
    local rot = transform.rot
    local scl = transform.scale
    local m = matrix()
    m = m:translate(pos.x, pos.y, 0)
    m = m:rotate(rot, 0, 0, 1)
    m = m:scale(scl.x, scl.y, 1)
    if transform.parent then
        return m * Transform.CTM(transform.parent)
    end
    return m
end

function Transform.PosToScreenPos(transform)
    local gm = transform.mtx or Transform.CTM(transform)
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
function Transform:isNeedsLayout()
    local isNeeds = false
    self.lastPos = self.lastPos or nil
    self.lastRot = self.lastRot or nil
    self.lastScale = self.lastScale or nil
    
    isNeeds = (self.lastPos ~= self.pos
        or self.lastRot ~= self.rot
        or self.lastScale ~= self.scale)
    if isNeeds then
        return true
    end
    if self.parent then
        isNeeds = self.parent:isNeedsLayout() or self.parent.didUpdate
    end
    return isNeeds
end
function Transform:setSelfDidLayout()
    self.lastPos = vec2(self.pos:unpack())
    self.lastRot = self.rot
    self.lastScale = vec2(self.scale:unpack())
end
function Transform:rotAngle()
    local fx, fy = self.forward:unpack()
    local angle = math.atan2(fy, fx)
    return angle * mathX.rad2deg
end
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
    local isDirty = self:isNeedsLayout()
    if isDirty then
        self.mtx = Transform.CTM(self)
        -- forward
        self.forward = vec2(self.mtx[1], self.mtx[2]):normalize()
        -- global position
        self.globalPos = vec2(self.mtx[13], self.mtx[14])
        
        -- global rotation
        local fx, fy = self.forward:unpack()
        local angle = math.atan2(fy, fx)
        self.globalRot = angle * mathX.rad2deg
        
        -- global scale
        self.globalScale = vec2(self.mtx[1]/1, self.mtx[6]/1)
        self:setSelfDidLayout()
        self.didUpdate = true
    else
        self.didUpdate = false
    end
    return self.didUpdate
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
end

function Transform:touched(touch)
    if touch and touch.state == BEGAN then
        if _editor then
            _editor:select(self)
        end
    end
end
