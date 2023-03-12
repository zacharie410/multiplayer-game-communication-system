-- SERVER SCRIPT
-- This script runs on the server

-- Get the Players service
local Players = game:GetService("Players")

-- Get the main folder of the server script
local mainFolder = script.Parent

local calculateListener = mainFolder:WaitForChild("BindableFunction")

-- Get the modules folder that contains the Events.lua module
local modules = mainFolder:WaitForChild("Modules")

-- Get the events table from the Events.lua module
local events = require(modules.Events)--server

-- Get the functions table from the Functions.lua module
local functions = require(modules.Functions) --server

-- Get the calcs table from the Calculations.lua module
local calculations = require(modules.Calculations)--Client and server resource

-- Get the rate limiter
local rateLimiter = require(modules.Utility.RateLimiter) --server)

-- Table to store available clients for function computation
local availableClients = {}


-- Function to add a client to the availableClients table
local function addAvailableClient(client)
	table.insert(availableClients, client)
end

-- Function to remove a client from the availableClients table
local function removeAvailableClient(client)
	for i, availableClient in ipairs(availableClients) do
		if availableClient == client then
			table.remove(availableClients, i)
			break
		end
	end
end

-- Function to validate the caller's token and event existence
local function validateCallerAndTask(Caller, Token, eventName, isFunction)
    -- If the caller is the server object, always return true
    if Caller == game then
        return true
    end
    
    -- If the caller does not match the player, kick them for attempting to exploit
    if Caller ~= Token then
        Caller:Kick("Kicked for attempting to exploit")
        return false
    end

    -- Get the appropriate event table based on whether the request is for a function or an event
    local eventTable = (isFunction and functions or events)

    -- If the event exists in the event table, return true
    if eventTable[eventName] then
        return true
    else
        -- If the event does not exist, kick the caller for attempting to exploit and return false
        Caller:Kick("Kicked for attempting to exploit")
        return false
    end
end

-- Function to validate the caller's token and calculation existence
local function validateCallerAndCalculation(Caller, Token, calcName)
    -- If the caller is the server object, always return true
    if Caller == game then
        return true
    end
    
    -- If the caller does not match the player, kick them for attempting to exploit
    if Caller ~= Token then
        Caller:Kick("Kicked for attempting to exploit")
        return false
    end

    -- If the calculation exists in the calculations table, return true
    if calculations[calcName] then
        return true
    else
        -- If the calculation does not exist, kick the caller for attempting to exploit and return false
        Caller:Kick("Kicked for attempting to exploit")
        return false
    end
end


-- Function to check if a user has the required permissions for a given task
local function hasPermissions(Token, requiredRole)
	-- Decode the user's token to get their role and permissions
	local role = Token:GetAttribute("role")
	return ((requiredRole or 0) <= (role or 0))
end

-- Function to handle incoming RemoteEvent requests from clients
function OnServerEvent(Client, Token, eventName, ...)
	-- Check the rate limit for the client
	if not rateLimiter:checkRateLimit(Client) then
		Client:Kick("You have exceeded your rate limit.")
		return
	end

	-- Validate the caller's token and event existence
	if validateCallerAndTask(Client, Token, eventName, false) then
		-- If the caller and event are valid, call the corresponding function from the events table with the provided arguments
		local Event = events[eventName]
		if hasPermissions(Token, Event['requiredRole']) then
			Event:Call(Client, ...)
		else
			print("This user does not have the required permissions")
		end
	end
end

-- Function to handle incoming RemoteFunction requests from clients
function OnServerFunction(Client, Token, functionName, ...)
	-- Check the rate limit for the client
	if not rateLimiter:checkRateLimit(Client) then
		Client:Kick("You have exceeded your rate limit.")
		return
	end

	-- Validate the caller's token and event existence
	if validateCallerAndTask(Client, Token, functionName, true) then
		local Function = functions[functionName]
		if hasPermissions(Token, Function['requiredRole']) then
			return Function:Call(Client, ...)
		else
			print("This user does not have the required permissions")
		end
	end
end

-- Function to handle calculation functions
function OnCalculateFunction(Caller, Token, calcName, ...)
	-- Validate the caller's token and calculation existence
	if validateCallerAndCalculation(Caller, Token, calcName) then
		-- If there are available clients, call the function on the first available client
		if #availableClients > 0 then
			local Client = availableClients[1]--Client refers to listener
			table.remove(availableClients, 1)
			return Client:InvokeClient(Caller, calcName, ...)
		else
			-- If there are no available clients, run the function on the server instead
			return calculations[calcName](Caller, ...)
		end
	end
end

calculateListener.OnServerInvoke = OnCalculateFunction; -- if called from server pass caller and token as game

-- Connect to the PlayerAdded event to listen for new players joining the game
Players.PlayerAdded:Connect(function(Player)
	-- Create a new RemoteEvent for the player to use for sending requests to the server
	local eventListener = Instance.new("RemoteEvent", Player)

	-- Create a new RemoteFunction for the player to use for calling server-side functions
	local functionListener = Instance.new("RemoteFunction", Player)

	-- Connect to the OnServerEvent function to handle incoming RemoteEvent requests from the client
	eventListener.OnServerEvent:Connect(function(Caller, eventName, ...)
		-- Call the OnServerEvent function with the provided arguments
		OnServerEvent(Caller, Player, eventName, ...)
	end)

	-- Connect to the OnServerInvoke function to handle incoming RemoteFunction requests from the client
	functionListener.OnServerInvoke = function(Caller, functionName, ...)
		-- Call the OnServerFunction function with the provided arguments
		return OnServerFunction(Caller, Player, functionName, ...)
	end

	--Assuming Player is Token
	Player:SetAttribute("role", 1)

	-- Add the player to the availableClients table when they connect
	addAvailableClient(functionListener)
end)

