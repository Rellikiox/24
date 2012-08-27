
local base = {}

base.pos_x 	= 0
base.pos_y 	= 0
base.z		= 0
base.vel_x 	= 0
base.vel_y 	= 0
base.w 		= 0
base.h 		= 0
base.health = 1
base.alive 	= true
base.color = {}

function base:setPos( x, y, z )
	base.pos_x = x
	base.pos_y = y
	base.z = z
end

function base:getPos()
	return base.pos_x, base.pos_y
end

function base:getZ()
	return base.z
end

function base:load()
end

function base:insideBoundingBox( px, py )
	if px > x and px < x + w then
		if py > y and py < y + w then
			return true
		end
	end
	return false
end

function base:getBBox()
	return self.pos_x, self.pos_y, self.w, self.h
end

function base:endCollision(block)
end

return base;