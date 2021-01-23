Circle = class(Transform)

function Circle:init(opt)
    opt = opt or {}
    opt.name = opt.name or 'Circle'
    Transform.init(self, opt)
    self.r = opt.r or 50
    self.pivot = vec2(0.5, 0.5)
    self.color = opt.color or color(255)
    self.forward = vec2(0, 1)
end
function Circle:buildTouchPoints()
    local size = self.r
    local ts = {
    vec2(-1, -1),
    vec2(1, -1),
    vec2(1, 1),
    vec2(-1, 1)
    }
    
    local p = {}
    for _, t in ipairs(ts) do
        local m = matrix()
        --local x =
        m = m:translate(t.x * size / 2, t.y * size / 2)
        m = m * self.mtx
        table.insert(p, vec2(m[13], m[14]))
    end
    
    return p
end
function Circle:onDraw()
    stroke(self.color)
    fill(self.color)
    strokeWidth(5)
    ellipse(0,0, self.r)
end

function Circle:touched(touch)
    Transform.touched(self, touch)
end
