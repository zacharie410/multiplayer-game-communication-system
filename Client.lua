-- CLIENT SCRIPT
-- This script runs on the client

-- Get the player's instance
local player = game.Players.LocalPlayer

-- Get the RemoteEvent from the player
local remoteEvent = player:WaitForChild("RemoteEvent")

-- Get the RemoteFunction object from the player
local remoteFunction = player:WaitForChild("RemoteFunction")

-- Function to call the server with a given event name and arguments
local function callServer(eventName, ...)
	-- Call the server's RemoteEvent with the event name and arguments
	remoteEvent:FireServer(eventName, ...)
end

-- Call the Example event on the server with the arguments "Hello" and "World"
callServer("example", "Hello", "World")

-- Function to call a server-side function with a given name and arguments
local function callServerFunction(functionName, ...)
	-- Call the server's RemoteFunction with the function name and arguments
	return remoteFunction:InvokeServer(functionName, ...)
end

-- Call the Example function on the server with the arguments "Hello" and "World"
local result = callServerFunction("Example", "Hello", "World")

-- Print the result returned from the server function
if result then
	print(result)
end

local function responseHandler(...)
	return "Success"
end

remoteFunction.OnClientInvoke = responseHandler



