-- ball.lua

require "colors"

Ball = { }
Ball.__index = Ball;

function Ball:new( )
	local this = { 
		x = 0,
		y = 0,
		speed = {
			x = 300,
			y = 300
		},
		speed_starting = 300, -- pixels per second
		speed_increment = 50, -- pixels per second
		speed_limit = 500, -- pixels per second
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
	self.speed.x = x > self.speed_limit and self.speed_limit or x
	self.speed.y = y > self.speed_limit and self.speed_limit or y
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
	local speed_x, speed_y = self:getSpeed()
	local player_x, player_y = player:getPosition()
	local width, height = player:getDimensions()

	if self.x + self.size > player_x and self.x < player_x + width and
	    self.y + self.size > player_y and self.y < player_y + height then

    	-- From: https://gamedev.stackexchange.com/questions/4253/in-pong-how-do-you-calculate-the-balls-direction-when-it-bounces-off-the-paddl
	   	local d = player_y + height/2 - (self.y)

    	speed_y = speed_y + d*(-0.1)

	    if (speed_x < 0) then 
	    	speed_x = -(speed_x - self.speed_increment)
	    	self.x = player_x + width;
	    else
	    	speed_x = -(speed_x + self.speed_increment)
	    	self.x = player_x - self.size
    	end

    	player:applyDamage( self.computeDamage() )
	end

	self:setSpeed(speed_x, speed_y)
end

function Ball:computeDamage( )
	return 10
end