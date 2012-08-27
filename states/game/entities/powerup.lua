local ent = ents:inherit("base")

function ent:load( x, y, name )
	self:setPos( x, y, 1 )
	self.birth = love.timer.getMicroTime()
	self.speed = 200
	if ( name == "damage" ) then
		self.color = { 255, 0, 0, 255 }
	elseif ( name == "life" ) then
		self.color = { 0, 255, 0, 255 }
	elseif (name == "speed" ) then
		self.color = { 0, 0, 255, 255 }
	end
	self.name = name
	self.w = 10
	self.h = 10
	
	self.shape = Collider:addRectangle( x, y, self.w, self.h)
	self.shape.parent = self
	self.shape:setRotation(0)
	Collider:addToGroup("powerups", self.shape)
end

function ent:update( dt )
	self.shape:setRotation(love.timer.getMicroTime() - self.birth)	
end

function ent:draw()
	love.graphics.setColor(unpack(self.color))
	self.shape:draw("line")
end

function ent:collision(other, dx, dy)
	if other.parent.type == "player" then
		self.alive = false
		local x, y = self.shape:center()
		ents:add( "wave", x, y, self.color )
		ents:add( "text", x, y, self.color, "+" .. string.upper(self.name), "small", 2 )
		for k, pu in pairs(ents:getEntities("powerup")) do
			if self.id ~= pu.id then
				local dx = math.abs( self.pos_x - pu.pos_x )
				local dy = math.abs( self.pos_y - pu.pos_y )
				if ( dx + dy <= 60 ) then
					pu.alive = false
				end
			end
		end
	end
end

function ent:die()
	Collider:remove(self.shape)
end

return ent