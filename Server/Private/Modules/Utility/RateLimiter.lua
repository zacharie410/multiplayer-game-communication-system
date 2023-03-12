-- Define the rate limiter nodule
local RateLimiter = {}

-- Define the rate limit settings
RateLimiter.rateLimit = 10 -- Set the maximum number of requests per time period
RateLimiter.timePeriod = 60 -- Set the time period in seconds
RateLimiter.requestCounts = {} -- Table to store request counts for each client

-- Function to check if a client has exceeded their rate limit
function RateLimiter:checkRateLimit(Client)
	-- Get the current time
	local currentTime = os.time()

	-- If the client's request count table does not exist, create it
	if not self.requestCounts[Client] then
		self.requestCounts[Client] = {count = 0, lastRequestTime = currentTime}
	end

	-- If the time period has elapsed since the last request, reset the request count and last request time
	if currentTime - self.requestCounts[Client].lastRequestTime > self.timePeriod then
		self.requestCounts[Client].count = 0
		self.requestCounts[Client].lastRequestTime = currentTime
	end

	-- Increment the request count for the client
	self.requestCounts[Client].count = self.requestCounts[Client].count + 1

	-- If the client has exceeded their rate limit, return false
	if self.requestCounts[Client].count > self.rateLimit then
		return false
	else
		return true
	end
end

return RateLimiter