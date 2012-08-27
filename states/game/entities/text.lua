local ent = ents:inherit("base")

function ent:load( x, y, color, text, mode, life )
	self:setPos( x, y, 0 )
	self.color = color	
	self.text = text
	self.birth = love.timer.getMicroTime()
	self.life = life
	self.mode = mode
	
	self.shape = Collider:addRectangle( x, y, 1, 1)
	self.shape.parent = self
	Collider:setGhost(self.shape)
end

function ent:update(dt)
	if (love.timer.getMicroTime() - self.birth > self.life ) then
		self.alive = false
	end
end

function ent:draw()
	love.graphics.setColor(unpack(self.color))
	love.graphics.setFont(caption_font)
	if (self.mode == "normal") then
		love.graphics.print(self.text, self.pos_x, self.pos_y)
	else
		love.graphics.printf(self.text, self.pos_x, self.pos_y, 0, "center")
	end
end

return ent