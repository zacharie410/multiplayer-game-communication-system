--SERVER

function ExampleEvent(Caller, ...)
	print(Caller .. " " .. (...))
	--event so return nothing
end

return ExampleEvent;


-- events module
local events = {
	Example = require(script.ExampleEvent),
}

return events;

