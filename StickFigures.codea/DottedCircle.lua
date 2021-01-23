DottedCircle = class(Transform)

function DottedCircle:init(opt)
    opt = opt or {}
    Transform.init(self, opt)
    self.cx = opt.cx or WIDTH / 2
    self.cy = opt.cy or HEIGHT / 2
    self.sides = opt.sides or 2
    self.r = opt.r or 25
    self.color = opt.color or color(255)
    self.points = {}
    self.thread = coroutine.create(self.invalidate)
end
math.rad2deg = 180 / math.pi
math.deg2rad = math.pi / 180

function DottedCircle:reload()
   -- if self.thread == nil then
        self.thread = nil
        self.thread = coroutine.create(self.invalidate)
 --   end
end
function DottedCircle:invalidate()
    local points = {}
    local section = 360 / self.sides / 2
    local sides = self.sides
    local r = self.r
    for i = 0, sides - 1, 1 do
        if i % 60 == 0 then 
            coroutine.yield()
        end
        -- local x = math.cos(i * math.pi * 2 / self.sides) * self.r
        --  local y = math.sin(i * math.pi * 2 / self.sides) * self.r
        local angle = i * section * math.deg2rad * 2
        print('angle', angle)
        local x = math.cos(angle) * r
        local y = math.sin(angle) * r
        print(i * section, x, y)
        table.insert(points, vec2(x, y))
    end
    print('======')
    return points
end
function DottedCircle:update()
    if self.thread then
        local status, result = coroutine.resume(self.thread, self)
        if result then
            self.points = result
            print(status)
            self.thread = nil
        end
    end
end
function DottedCircle:draw()
    self:update()
    pushMatrix() pushStyle()
    translate(self.cx, self.cy)
    noStroke()
    fill(self.color)
    ellipse(0,0, 5)
    for k, p in ipairs(self.points) do
        --local x = math.cos(i * section) * self.r
       -- local y = -math.sin(i * section) * self.r
        ellipse(p.x, p.y, 5)
    end
    popMatrix() popStyle()
    -- Codea does not automatically call this method
end

function DottedCircle:touched(touch)
    -- Codea does not automatically call this method
end
