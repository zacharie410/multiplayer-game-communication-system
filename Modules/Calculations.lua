-- CALCULATIONS MODULE
-- This module contains calculations that can be run on both the server and the client
--

function Calculate(Caller, ...)
	return print(Caller .. " " .. (...))
end

return Calculate;

--
local calculations = {
	Calculate = require(script.Calculate)
}

return calculations;