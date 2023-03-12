-- Define the module
local ExampleEvent = {}

-- Define the required role for this module
ExampleEvent.requiredRole = 1 -- Set this to the minimum role level required to access the module

-- Define the example event function
function ExampleEvent:Call(Caller, ...)
	print(Caller .. " " .. (...))
	-- Event function, so return nothing
end

-- Return the module
return ExampleEvent