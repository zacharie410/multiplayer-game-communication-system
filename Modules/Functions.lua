--SERVER
--ExampleFunction module
function ExampleFunction(Caller, ...)
	return "Success!"
end

return ExampleFunction;

--functions module
local functions = {
	Example = require(script.ExampleFunction),
}

return functions;