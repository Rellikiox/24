local ent = ents:inherit("base")

function ent:load( x, y, color )
	self:setPos( x, y, 6 )
	self.color = { 52, 52, 52, 255 }
	self.rot = 0
	self.w = 10
	self.h = 10
	
	self.shape = Collider:addRectangle(self.pos_x, self.pos_y, self.w, self.h)
	self.shape.parent = self
	Collider:setPassive(self.shape)
	Collider:addToGroup("walls", self.shape)
end

function ent:draw()
	love.graphics.setColor(unpack(self.color))
	self.shape:draw("fill")
end

function ent:collision(other, dx, dy)
	if other.parent.type == "bullet" then
		other.parent.alive = false
	end
end

function ent:die()
	Collider:remove(self.shape)
end

return ent