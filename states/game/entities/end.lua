local ent = ents:inherit("base")

function ent:load( x, y )
	
	self.shape = Collider:addRectangle( x, y, 10, 10)
	self.shape.parent = self
	
end

function ent:draw()
	love.graphics.setColor(255,0,255)
	self.shape:draw("line")
end

function ent:collision(other, dx, dy)
	if other.parent.type == "player" then
		loadNextLevel()
	end
end

return ent