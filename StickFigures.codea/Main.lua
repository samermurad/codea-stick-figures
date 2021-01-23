-- StickFigures
-- Use this function to perform your initial setup


function table.concat(t1, t2)
    for _,v in ipairs(t2) do
        table.insert(t1, v)
    end
end
function setup()
    --readImage()
    list = { }
    
    table.concat(list, {sword(color(255, 181, 0))})
    
    table.concat(list, {stickman()})
    local _s2 = {stickman(color(0))}
    _s2[1].pos.x = _s2[1].pos.x + 150
    table.concat(list, _s2)
    touches.addHandler(list)
    local colors = {}
    for i, v in ipairs(list) do
        local rnd = list[i].color or color(math.random(50, 255), math.random(50, 255), math.random(60, 255))
        table.insert(colors, rnd)
        
    end
    function list:draw()
        for i, v in ipairs(self) do
            pushMatrix()
         --   zLevel(i)
            v:draw()
            popMatrix()
        end
    end
    function list:touched(touch)
        if touch.state == BEGAN then
            for i, v in ipairs(self) do
                if v:hitTest(touch) then
                    v:touched(touch)
                end
            end
        end
    end
    
    
    _editor = T2DEditor()
end

function draw()
    background(128)
    list:draw()
    _editor:draw()
end

--[[
function touched(touch)
    list:touched(touch)
    _editor:touched(touch)
end
]]--
