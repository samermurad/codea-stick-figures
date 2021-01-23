T2DEditor = class()

function T2DEditor:init()
    self.sTransform = nil
    
    self.pos = vec2(WIDTH - 300, HEIGHT/2 - 300)
  
    self.doDraw = false
    self.gizmo = Gizmo()
  --  touches.addHandler(self)
end

function T2DEditor:select(transform)
    if self.sTransform ~= transform and transform ~= nil then
        print('new selection', transform.globalPos, transform.name)
        self.sTransform = transform
        self.doDraw = self.sTransform ~= nil
        if self.doDraw then
            self:refreshParametersApi()
        else
            parameter.clear()
        end
        print('should draw', self.doDraw)
    end
end

function T2DEditor:refreshParametersApi()
    local t = self.sTransform
    local rot = t.rot
    local pos = t.pos
    local scl = t.scale
    
    parameter.clear()
    
    parameter.text(t.name)
    if t.parent then
        parameter.action('Jump to Root Parent', function()
            local p = t.parent
            while p.parent ~= nil do
                p = p.parent
            end
            self:select(p)
        end)
        parameter.action('Jump to Next Parent', function()
            self:select(t.parent)
        end)
    end
    parameter.integer(
    'itemRot', -360, 360, rot,
    function(val)
         t.rot = val
    end
    )
    
    parameter.number('itemX', -WIDTH, WIDTH, pos.x, function(val)
        t.pos.x = val
    end)
    parameter.number('itemY', -HEIGHT, HEIGHT, pos.y, function(val)
        t.pos.y = val
    end)
    
    parameter.number('scaleX', -5, 5, scl.x, function(val)
        t.scale.x = val
    end)
    parameter.number('scaleY',-5, 5, scl.y, function(val)
        t.scale.y = val
    end)
    if t.color then
        parameter.color('itemColor', t.color, function(val)
            t.color = val
        end)
    end
end
function T2DEditor:calculateGizmoPos()
    
end
function T2DEditor:update()
    self.doDraw = self.sTransform ~= nil
    self.gizmo:update()
    if self.sTransform ~= nil then
     --   print('seetting the gizmo', self.sTransform.globalPos)
        self.gizmo.pos = Transform.PosToScreenPos(self.sTransform)
        self.gizmo.rot = self.sTransform.globalRot
    end
    
end
function T2DEditor:draw()
    self:update()
    if self.doDraw then
        self.gizmo:draw()
        pushMatrix() pushStyle()
        resetMatrix()
        stroke(153, 233, 80, 162)
        strokeWidth(1)
        noSmooth()
        local p = self.sTransform.touchPoints
        local first
        for i, v in pairs(p) do
            
            if i == 1 then
                first = v
                line(first.x, first.y, p[#p].x, p[#p].y)
            end
            if first then
                line(first.x, first.y, v.x, v.y)
                first = v
            end
        end
        popMatrix() popStyle()
    end
    
    
    -- Codea does not automatically call this method
end

--function T2DEditor:touched(touch)
    -- Codea does not automatically call this method
  --  print('yes')
    -- self.panel:touched(touch)
--end

function rRect(w,h,r,c)
    strokeWidth(0)
    fill(c.r, c.g, c.b, c.a)
    ellipse(r/2,h-r/2,r) ellipse(w-r/2,h-r/2,r)
    ellipse(r/2,r/2,r) ellipse(w-r/2,r/2,r)
    rect(0,r/2,w,h-r) rect(r/2,0,w-r,h)
end