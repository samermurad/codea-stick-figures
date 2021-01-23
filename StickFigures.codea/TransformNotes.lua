--- Transform Notes, Matrices Examples


--[[
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

--]]