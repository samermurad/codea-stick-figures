Stick = class(Transform)

function Stick:init(opt)
    -- you can accept and set parameters here
    opt = opt or {}
    opt.name = opt.name or 'Stick'
    Transform.init(self, opt)
    self.length = opt.length or 150
    self.width = opt.width or 15
    self.color = opt.color or color(255)
    
    self.connected = type(opt.connected) ~= 'boolean' and true or opt.connected

end

function Stick:update()
    self.mode = CORNER
    local didUpdate = Transform.update(self)
end

function Stick:onDraw()
    if self.width <= 3 then
        noSmooth()
    else
        smooth()
    end
    lineCapMode(ROUND)


    strokeWidth(self.width)
    stroke(self.color)
    line(0, 0, self.length, 0)
    
end


function Stick:buildTouchPoints()
    local d = self.width / 2
    local d2 = d + self.length

    local ts = {
        vec2(-d, d),
        vec2(-d, -d),
        vec2(d2, -d),
        vec2(d2, d)
    }
    
    local p = {}
    for _, t in ipairs(ts) do
        local m = matrix()
        m = m:translate(t.x, t.y)
        m = m * self.mtx
        table.insert(p, vec2(m[13], m[14]))
    end
    
    return p
end

function Stick:touched(touch)
    Transform.touched(self, touch)
    -- Codea does not automatically call this method
end
