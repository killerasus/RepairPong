-- main.lua
require "ball"
require "player"

-- Declare actors
player1 = Player:new()
player2 = Player:new()
ball = nil
next_player_1 = true

function love.load()
    -- Sets the random seed
    math.randomseed( os.time() )
    local width
    local height
    width, height = player1:getDimensions()
    y = love.graphics.getHeight()/2 - height/2

    player1:setPosition( 20, y )
   	player2:setPosition( love.graphics.getWidth() - width - 20 , y )
   	player2:setUpKey( "i" )
   	player2:setDownKey( "k" )
    player2:setRepairKey( "m" )
end

function love.draw()
    drawScores()
    drawField()
    player1:draw()
    player2:draw()

    if (ball) then
	   ball:draw()
    end
end

function love.update(dt)
    player1:update( dt )
    player2:update( dt )
    
    if (ball) then
        ball:update( dt )
        ball:checkPlayerCollision( player1 )
        ball:checkPlayerCollision( player2 )
        checkBallWallCollision( )
    else
        if love.keyboard.isDown("space") then
            setBallInGame()
        end
    end
end

function checkBallWallCollision( )
	x, y = ball:getPosition()
	speed_x, speed_y = ball:getSpeed()
	if ball.y < 0 then -- Upper wall collision
        y = 0
        speed_y = -speed_y
    elseif ball.y + ball.size > love.graphics.getHeight() then -- Lower wall collision
        y = love.graphics.getHeight() - ball.size
        speed_y = -speed_y
    end
    

    if ball.x < 0 then -- Left wall collision (Player 1 field)
    	x = 0
        speed_x = -speed_x
        player2.score = player2.score + 1
        ball = nil
        next_player_1 = true
    elseif ball.x + ball.size > love.graphics.getWidth() then -- Right wall collision (Player 2 field)
    	x = love.graphics.getWidth() - ball.size
    	speed_x = -speed_x
    	player1.score = player1.score + 1
        ball = nil
        next_player_1 = false
    end

    if (ball) then        
        ball:setPosition(x, y)
        ball:setSpeed(speed_x, speed_y)
    end
end

function drawScores( )
    love.graphics.setColor(Colors.White)
	love.graphics.print( player1.score, 310, 0, 0, 5 )
    love.graphics.print( player2.score, 450, 0, 0, 5 )
end

function drawField()
    local rect_sizex = 10
    local rect_sizey = 40
    local space = 10
    local repeats = love.graphics.getHeight()/rect_sizey
    
    love.graphics.setColor(Colors.White)
    for i = 0, repeats do
        love.graphics.rectangle( 'fill', love.graphics.getWidth()/2 - rect_sizex/2, 
        	i*(space + rect_sizey) + 5, rect_sizex, rect_sizey)
    end
end

function setBallInGame( )
    ball = Ball:new()
    ball:setPosition( love.graphics.getWidth()/2 - ball.size/2, love.graphics.getHeight()/2 - ball.size/2 )

    if next_player_1 then
        local _, y = player1:getPosition()
        local _, height = player1:getDimensions()
        y = y + height/2
        ball:setPosition( love.graphics.getWidth()/2 - ball.size/2, y - ball.size/2)
        ball:setSpeed( ball.speed_starting, ball.speed_starting )
    else
        local _, y = player2:getPosition()
        local _, heigh = player2:getDimensions()
        y = y + height/2
        ball:setPosition( love.graphics.getWidth()/2 + ball.size/2, y - ball.size/2)
        ball:setSpeed( -ball.speed_starting*math.random(0.9, 1.4), ball.speed_starting*math.random(0.9, 1.4) )
    end
end