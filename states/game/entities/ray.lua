local ent = ents:inherit("base")

local max_life = 0.1

function ent:load( x0, y0, x1, y1, parent )
	
	self:setPos(x0,y0, -1)
	local dx = x1 - x0
	local dy = y1 - y0
	self.shape = Collider:addRectangle( x0, y0, math.sqrt(dx * dx + dy * dy), 1)
	self.shape:setRotation(math.atan2(y1 - y0, x1 - x0), x0, y0)
	self.shape.parent = self
	Collider:addToGroup("rays", self.shape)
	
	self.birth = love.timer.getMicroTime()
	self.parent = parent
end

function ent:update(dt)
	if (love.timer.getMicroTime() - self.birth > max_life) then
		self.parent.vision = true
		self.alive = false
	end
end

function ent:collision(other, dx, dy)
	if (other.parent.type == "wall") then
		self.alive = false
		self.parent.vision = false
		Collider:remove(self.shape)
	end
end

function ent:die()
	Collider:remove(self.shape)
end

return ent