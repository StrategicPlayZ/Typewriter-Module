-- // By StrategicPlayZ \\ --

local RunService = game:GetService("RunService")

-- Thread/Yield storage
local threads = {}
local n_threads = 0

RunService.Stepped:Connect(function(_, delta_time)
	-- Do not execute if no yields are present
	if (n_threads == 0) then return end

	-- Get the [current_time]
	local current_time = os.clock()

	-- Loop through all the running yields
	local thread_index = 1
	while (thread_index < n_threads) do
		-- Fetch the [thread] and its [resume_time]
		local resume_time_index = (thread_index + 1)

		local thread, resume_time = threads[thread_index], threads[resume_time_index]

		-- If the current [index] is nil then break out of the loop
		if (not thread) then break end

		-- Time elapsed since the current yield was started
		local difference = (resume_time - current_time)

		-- If the yield has been completed
		if (difference <= 0) then
			-- Remove it from [threads] table
			if (resume_time_index ~= n_threads) then
				threads[thread_index] = threads[n_threads - 1]
				threads[resume_time_index] = threads[n_threads]

				threads[n_threads - 1] = nil
				threads[n_threads] = nil

				n_threads -= 2

				-- Resume the [thread] (stop the yield)
				coroutine.resume(thread, current_time)

				continue
			else
				threads[thread_index] = nil
				threads[resume_time_index] = nil

				n_threads -= 2

				-- Resume the [thread] (stop the yield)
				coroutine.resume(thread, current_time)
			end
		end
		thread_index += 2
	end
end)

-- Main function that is executed when the module is used
local function FastWait(wait_time)
	-- Verifies [wait_time]
	wait_time = tonumber(wait_time) or (0)

	-- Mark [start] time
	local start = os.clock()

	-- Get running [thread]
	local thread = coroutine.running()

	-- Insert it in [threads] table
	threads[n_threads + 1] = thread
	threads[n_threads + 2] = (start + wait_time)

	n_threads += 2

	-- Wait until the coroutine resumes (the yielding finishes)
	local current_time = coroutine.yield()

	-- Return: (time_it_waited, current_time)
	return (current_time - start), current_time
end

return FastWait
