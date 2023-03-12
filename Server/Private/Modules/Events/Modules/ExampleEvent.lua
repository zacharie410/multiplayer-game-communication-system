function ExampleEvent(Caller, ...)
	print(Caller .. " " .. (...))
	--event so return nothing
end

return ExampleEvent;
