local ent = ents:inherit("base")

function ent:load( x, y, color, angle, damage, parent, size )
	self:setPos( x, y, 5 )
	self.color = color
	self.w = 2
	self.h = 2
	self.speed = 300
	self.damage = damage
	self.parent = parent
	
	self.shape = Collider:addRectangle( x, y, size, size)
	self.shape.parent = self
	self.shape:setRotation(angle)
	self.shape.velocity = { x = math.cos(angle) * self.speed, y = math.sin(angle) * self.speed }
	Collider:addToGroup("bullets", self.shape)
end

function ent:update( dt )
	self.shape:move(self.shape.velocity.x * dt, self.shape.velocity.y * dt)
end

function ent:draw()
	love.graphics.setColor(unpack(self.color))
	self.shape:draw("fill")
end

function ent:collision(other, dx, dy)
	if other.parent.type == "wall" or other.parent.type == "enemy" then
		self.alive = false
	end
end

function ent:die()
	Collider:remove(self.shape)
end

return ent