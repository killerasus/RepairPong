-- ball.lua

require "colors"

Ball = { }
Ball.__index = Ball;

function Ball:new( )
	local this = { 
		x = 0,
		y = 0,
		speed = {
			x = 100,
			y = 100
		},
		speed_increment = 15,
		size = 16, -- pixels
		color = Colors.Green -- r, g, b, a
	}
	setmetatable(this, self)
	return this
end

function Ball:setPosition( x, y )
	self.x = x
	self.y = y
end

function Ball:getPosition( )
	return self.x, self.y
end

function Ball:setSpeed( x, y )
	self.speed.x = x
	self.speed.y = y
end

function Ball:getSpeed( )
	return self.speed.x, self.speed.y
end

function Ball:setColor( t )
	self.color = t;
end

function Ball:draw( )
	love.graphics.setColor( self.color )
	love.graphics.rectangle( 'fill', self.x, self.y, self.size, self.size) 
end

function Ball:update( dt )
	self:setPosition( self.x + self.speed.x*dt, self.y + self.speed.y*dt )
end

function Ball:checkPlayerCollision( player )
	speed_x, speed_y = self:getSpeed()
	player_x, player_y = player:getPosition()
	width, height = player:getDimensions()

	if self.x + self.size > player_x and self.x < player_x + width and
	    self.y + self.size > player_y and self.y < player_y + height then
	    if (speed_x < 0) then 
	    	speed_x = -(speed_x - self.speed_increment)
	    else
	    	speed_x = -(speed_x + self.speed_increment)
    	end
    	player:applyDamage( self.computeDamage() )
	end

	self:setSpeed(speed_x, speed_y)
end

function Ball:computeDamage( )
	return 10
end