local ent = ents:inherit("base")

local max_life = 1

function ent:load( x, y, color )
	self:setPos( x, y, 5 )
	self.birth = love.timer.getMicroTime()
	self.speed = 200
	self.radius = 0
	self.color = color
	
	self.shape = Collider:addRectangle( x, y, 1, 1)
	self.shape.parent = self
	Collider:setGhost(self.shape)
end

function ent:update( dt )
	local life_time = love.timer.getMicroTime() - self.birth
	if (life_time > max_life) then
		self.alive = false
	else
		self.radius = self.radius + self.speed * dt
		self.speed = self.speed - love.timer.getDelta() * 100
		self.color[4] = (max_life - life_time) * 255
	end
end

function ent:draw()
	love.graphics.setColor(unpack(self.color))
	love.graphics.circle("line", self.pos_x, self.pos_y, self.radius)
end

return ent