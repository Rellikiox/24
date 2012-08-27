local ent = ents:inherit("base")

local max_life = 1
local inv_time = 1
local ray_interval = 0.5

function ent:load( x, y, level )
	self:setPos( x, y, 5 )
	self.color = { 0, 0, 0, 255 }
	self.w = 5 + level
	self.h = 5 + level
	self.rot = 0
	self.speed = 50 + level * 5
	self.health = level * 5
	self.last_hit = 0
	self.inv = true
	self.vision = false
	
	self.shape = Collider:addRectangle(x, y, self.w, self.h)
	self.shape.parent = self
	self.shape.velocity = { x = 0, y = 0 }
	Collider:addToGroup("enemies", self.shape)
	
	self.sounds = {
		hurt = "sounds/hurt.wav",
		shoot = "sounds/shoot.wav"
	}
	
	self.last_ray = love.timer.getMicroTime()
end

function ent:update( dt )
	local sx, sy = self.shape:center()
	local px, py = player.shape:center()
	local dir_x = px - sx
	local dir_y = py - sy
	local dist = math.sqrt(dir_x * dir_x + dir_y * dir_y)
	
	if dist < 300 then
	
		if self.inv then
			if (love.timer.getMicroTime() - self.last_hit > inv_time) then
				self.inv = false
				self.color[4] = 255
			end
		end
				
		if self.vision then
			self.shape:setRotation(math.atan2( dir_y, dir_x ))
			local vel_x = dir_x / dist
			local vel_y = dir_y / dist
			self.shape.velocity.x = vel_x * self.speed
			self.shape.velocity.y = vel_y * self.speed
		else
			self.shape.velocity.x = 0
			self.shape.velocity.y = 0
		end
		
		if ( love.timer.getMicroTime() - self.last_ray > ray_interval ) then
			ents:add("ray", sx, sy, px, py, self)
			self.last_ray = love.timer.getMicroTime()
			
		end
		
		self.shape:move(self.shape.velocity.x * dt, self.shape.velocity.y * dt)
	end
end

function ent:draw()
	love.graphics.setColor(unpack(self.color))
	self.shape:draw("fill")
end
	

function ent:take_hit( damage, makes_inv )
	
	if not makes_inv then
		self.health = self.health - damage
		TEsound.play(self.sounds.hurt)
		if (self.health <= 0) then
			self.alive = false
			if math.random(0, 100) > 90 then
				local x, y = self.shape:center()
				local names = {"damage", "life", "speed" }
				ents:add("powerup", x, y, names[math.random(#names)])
			end
		end
	elseif not self.inv then
		TEsound.play(self.sounds.hurt)
		self.color[4] = 100
		self.inv = true
		self.last_hit = love.timer.getMicroTime()
		self.health = self.health - damage
		if (self.health <= 0) then
			self.alive = false
			if math.random(0, 100) > 90 then
				local x, y = self.shape:center()
				local names = {"damage", "life", "speed" }
				ents:add("powerup", x, y, names[math.random(#names)])
			end
		end
	end
end

function ent:collision(other, dx, dy)
	if (other.parent.type == "wall") then
		self.shape:move(dx, dy)
	elseif (other.parent.type == "bullet") then
		self:take_hit(other.parent.damage, false)
	end
end

function ent:die()
	Collider:remove(self.shape)
end

return ent