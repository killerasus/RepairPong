-- player.lua

require "colors"

Player = { }
Player.__index = Player;

function Player:new( )
	local this = {	
		paddle = { 
			height = 80,
			width = 20,
			position = {
				x = 0,
				y = 0
			}
		},
		control = {
			keyboard = {
				up = "w",
				down = "s",
				repair = "x"
			}
		},
		speed = 350,
		health = 100,
		repair_timer = 0,
		repair_delay = 2, -- in seconds
		repair_in_cooldown = false,
		score = 0,
		color = Colors.Green
	}
	setmetatable(this, self)
	return this
end

function Player:getDimensions( )
	return self.paddle.width, self.paddle.height
end

function Player:setPosition( x, y )
	self.paddle.position.x = x;
	self.paddle.position.y = y;
end

function Player:getPosition( )
	return self.paddle.position.x, self.paddle.position.y
end

function Player:setUpKey( up )
	self.control.keyboard.up = up
end

function Player:getUpKey( )
	return self.control.keyboard.up
end

function Player:setDownKey( down )
	self.control.keyboard.down = down
end

function Player:getDownKey( )
	return self.control.keyboard.down
end

function Player:setRepairKey( repair )
	self.control.keyboard.repair = repair
end

function Player:setColor( t )
	self.color = t;
end

function Player:draw( )
	love.graphics.setColor( self.color )
	love.graphics.rectangle( 'fill', self.paddle.position.x, self.paddle.position.y, self.paddle.width, self.paddle.height)
end

function Player:update( dt )
	local x, y = self:getPosition()

	if not self.repair_in_cooldown then
		if self.health > 75 then
			self:setColor( Colors.Green )
		elseif (self.health < 75 and self.health > 35) then
			self:setColor( Colors.Yellow )
		else
			self:setColor( Colors.Red )
		end

		if love.keyboard.isDown(self.control.keyboard.up) then
			y = y - self.speed*dt
	    end
	    
	    if love.keyboard.isDown(self.control.keyboard.down) then
	    	y = y + self.speed*dt
	    end
	end

	-- For testing cooldown mechanic
	if self.repair_in_cooldown then
		self.repair_timer = self.repair_timer + dt
		if self.repair_timer >= self.repair_delay then
			self.health = 100
			self.repair_in_cooldown = false
			self.repair_timer = 0
			self:setColor(Colors.Green)
		end
		-- print("Timer " .. self.repair_timer)
	end

	if love.keyboard.isDown(self.control.keyboard.repair) and not self.repair_in_cooldown then
		self:repair()
	end
    
    -- Check for boundaries
    if y < 0 then
        y = 0
    elseif y + self.paddle.height > love.graphics.getHeight() then
        y = love.graphics.getHeight() - self.paddle.height
    end

    self:setPosition(x, y)
end

function Player:repair( )
	self:setColor(Colors.Blue)
	self.repair_timer = 0
	self.repair_in_cooldown = true
end

function Player:applyDamage( dmg )
	self.health = self.health - dmg
end