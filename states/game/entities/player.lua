local ent = ents:inherit("base")

local gun_cooldown = 0.2 -- seconds between shoots
local inv_time = 1

function ent:load( x, y )
	self:setPos(x, y, 1)
	self.size = 10
	self.speed = 100
	self.color = { 255, 255, 255, 255 }
	self.damage = 5
	self.life = 50
	
	self.shape = Collider:addRectangle(self.pos_x, self.pos_y, self.size, self.size)
	self.shape.parent = self
	self.shape.velocity = { x = 0, y = 0 }
	
	self.last_shoot = 0
	self.last_hit = 0
	
	
	self.powerups = {
		cant = 0,
		inc_func = function (name)
			self.powerups.cant = self.powerups.cant + 1
			self.powerups[name].cant = self.powerups[name].cant + 1
		end,
		dec_func = function (name)
			self.powerups.cant = self.powerups.cant - 1
			self.powerups[name].cant = self.powerups[name].cant - 1
		end,
		damage = {
			increment = function () 
				self.powerups.inc_func("damage")
				self.damage = self.damage + 5
			end,
			decrement = function ()
				self.powerups.dec_func("damage")
				self.damage = self.damage - 5
			end,
			cant = 0,
		},
		life = {
			increment = function () 
				self.powerups.inc_func("life")
				local prev_size = self.size
				self.size = self.size + 1
				self.shape:scale(self.size / prev_size)
			end,
			decrement = function ()
				self.powerups.dec_func("life")
				local prev_size = self.size
				self.size = self.size - 1
				self.shape:scale(self.size / prev_size)
				if (self.size <= 0) then
					self.alive = false
					local x, y = self.shape:center()
					ents:add( "text", x, y, { 0, 0, 0 }, "GAME OVER", "small", 4 )
				end
			end,
			cant = 0,
		},
		speed = {
			increment = function () 
				self.powerups.inc_func("speed")
				self.speed = math.min(self.speed + 25, 350)
				gun_cooldown = math.max(gun_cooldown - 0.05, 0.15)
			end,
			decrement = function ()
				self.powerups.dec_func("speed")
				self.damage = self.damage - 5
			end,
			cant = 0,
		}
	}
	
	-- Sounds
	self.sounds = {
		hit = "sounds/hit.wav",
		pickup = "sounds/pickup.wav",
		shoot = "sounds/shoot.wav"
	}
end

function ent:take_hit(emiter)
	if emiter.type == "enemy" then
		if not self.inv then
			self.color[4] = 100
			self.inv = true
			self.last_hit = love.timer.getMicroTime()
			self.life = self.life - 10
			TEsound.play(self.sounds.hit)
			if (self.life <= 0) then
				restartLevel()
			end
		end
	else
		self.powerups.life.decrement()
		TEsound.play(self.sounds.hit)
	end
end

function ent:pickup(powerup)
	self.powerups[powerup.name].increment()
	self.color[1] = (self.powerups.damage.cant / self.powerups.cant) * 255
	self.color[2] = (self.powerups.life.cant / self.powerups.cant) * 255
	self.color[3] = (self.powerups.speed.cant / self.powerups.cant) * 255
	TEsound.play(self.sounds.pickup)
end

function ent:update(dt) 

	self:checkInput()
	
	self:updateFlags()
	
	-- update position
	self:updatePosition(dt)
	-- check for collisions
	
	-- update the animations
	self:updateAnimations(dt)
end

function ent:updateFlags()
	if self.inv then
		if (love.timer.getMicroTime() - self.last_hit > inv_time) then
			self.inv = false
			self.color[4] = 255
		end
	end
end

function ent:updatePosition(dt)
	self.shape:move(self.shape.velocity.x * dt, self.shape.velocity.y * dt)
	--self.pos_x,self.pos_y = self.shape:center()
end

function ent:updateAnimations(dt)

end

function ent:checkInput()
	-- up / down
	if control.up and not control.down then
		self.shape.velocity.y = self.speed * -1
	elseif control.down and not control.up then
		self.shape.velocity.y = self.speed
	else
		self.shape.velocity.y = 0
	end
	-- left / right
	if control.left and not control.right then
		self.shape.velocity.x = self.speed * -1
	elseif control.right and not control.left then
		self.shape.velocity.x = self.speed
	else
		self.shape.velocity.x = 0
	end
	-- angle
	self.shape:setRotation(-math.atan2( 300 - love.mouse.getY(), love.mouse.getX() - 400 ))
	-- shoot
	if love.mouse.isDown("l") then
		self:shoot()
	end
end

function ent:shoot()
	local timestamp = love.timer.getMicroTime()
	if ( timestamp - self.last_shoot > gun_cooldown ) then
		self.last_shoot = timestamp
		local x, y = self.shape:center()
		ents:add( "bullet", x, y, { 255, 255, 255, 255 }, self.shape:rotation(), self.damage, self, 2 + self.powerups.damage.cant )
		TEsound.play(self.sounds.shoot)
	end
end

function ent:draw() 
	love.graphics.setColor(unpack(self.color))
	self.shape:draw("fill")
end

function ent:collision(other, dx, dy)
	if (other.parent.type == "powerup") then
		self:pickup(other.parent)
	elseif (other.parent.type == "wall") then
		self.shape:move(dx, dy)
	elseif (other.parent.type == "enemy") then
		self:take_hit(other.parent)
	elseif (other.parent.type == "bullet" and not other.parent.parent.type == "player") then
		self:take_hit(other.parent)
	end
end

function ent:die()
end

return ent