-- Define the module
local ExampleFunction = {}

-- Define the required role for this module
ExampleEvent.requiredRole = 1 -- Set this to the minimum role level required to access the module

-- Define the example call
function ExampleFunction:Call(Caller, ...)
	print(Caller .. " " .. (...))
	return "result"
end

-- Return the module
return ExampleFunction