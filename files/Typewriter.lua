--[[
	
	[LAST-MODIFIED]: 7th February 2021
	
	[Made by]:
		Username: StrategicPlayZ
		UserId: 498916107
	
	Typewriter effect, supports RichText!
	
	[Documentation/Discussion]: https://devforum.roblox.com/t/supports-richtext-typewriter-module/946868
	[Updates]: https://devforum.roblox.com/t/typewriter-module-updates/1001018
]]

local main_type_writer_table = {} -- Contains function [ TypeWriter.new() ].

local FastWait = require(script.FastWait)
local RunService = game:GetService("RunService")

-- // Main \\ --
local type_writer_object_table = {} -- Contains functions of the object returned by [ TypeWriter.new() ].

function main_type_writer_table.new() --> Object Typer
	local self = setmetatable({}, {__index = type_writer_object_table})
	self.__on_text_updated = Instance.new("BindableEvent")
	self.__on_typer_finished = Instance.new("BindableEvent")
	self.__stop_signal = false
	self.__pause = false
	self.__running = false
	self.__interval = 0.03
	
	self.OnTextUpdated = self.__on_text_updated.Event -- Fires when text updates
	self.OnTyperFinished = self.__on_typer_finished.Event -- Fires when typer finishes typing
	return self
end

-- // TypeWriter Object Functions \\ --
-- // Type text

-- Check if rich text tag is valid
local check_if_valid_tag do
	-- Tags configuration
	local rich_text_tags = {
		["<b>"] = "</b>";
		["<i>"] = "</i>";
		["<u>"] = "</u>";
		["<s>"] = "</s>";
		["<smallcaps>"] = "</smallcaps>";
		["<sc>"] = "</sc>";

		['<font color=".-">'] = "</font>";
		['<font size=".-">'] = "</font>";
		['<font face=".-">'] = "</font>";

		["<!--.--->"] = false;
		["<br />"] = false;

		["&lt;"] = true;
		["&gt;"] = true;
		["&quot;"] = true;
		["&apos;"] = true;
		["&amp;"] = true;
	}
	-- Function
	function check_if_valid_tag(text)
		if (not text) then return nil end
		
		local tag = rich_text_tags[text]
		if (not tag) then -- If the tag is not "absolute", search for it using string pattern
			for start_tag, end_tag in pairs(rich_text_tags) do
				if (not string.find(text, start_tag)) then continue end
				tag = end_tag
				break
			end
		end
		return tag
	end
end

-- Main function for typewriting text
function type_writer_object_table:TypeText(final_text, interval, rich_text, yield)
	self:Stop()
	self.__stop_signal = false

	local function execute()
		local length = #final_text
		self.__interval = interval
		
		self.__running = true
		
		if (rich_text) then
			-- // CODE FOR RICH TEXT \\ --
			local pile_up_table = {} -- List of "end tags" such as </b>, </i>, etc
			local n_pile_up_table = 0 -- Number of values in the list
			
			local current_text = ""
			
			local index = 1
			while ((index <= length) and (not self.__stop_signal)) do
				
				-- Pause loop
				if (self.__pause) then
					self.__running = false
					while (self.__pause) do
						RunService.Heartbeat:Wait()
					end
					self.__running = true
				end
				
				local current_character = string.sub(final_text, index, index)
				if (current_character == " ") then -- Ignore blank spaces
					current_text ..= current_character
					index += 1
					continue -- Skip to the next iteration
				elseif (current_character == "<") then -- Check for tag
					local possible_tag = string.match(final_text, "<.->", index) -- Find the name of the possible tag
					local find = table.find(pile_up_table, possible_tag) -- Check if it is an end tag and present in pile_up_table
					if (find) then -- If it is then:
						table.remove(pile_up_table, find) -- Remove it from the list
						n_pile_up_table -= 1
						
						current_text ..= possible_tag -- Append it to current_text
						
						index += (#possible_tag) -- Increase the index to avoid looping through the tag
						
						continue -- Skip to the next iteration
					end
					-- [IF THE ABOVE IF STATEMENT WAS NOT TRUE]
					
					local end_tag = check_if_valid_tag(possible_tag) -- Find ending tag
					if (end_tag) then -- If end_tag exists in the configuration
						table.insert(pile_up_table, 1, end_tag) -- Insert it at the beginning of the table
						n_pile_up_table += 1

						current_text ..= possible_tag -- Append possible_tag to current_text
						self.__on_text_updated:Fire(current_text, final_text) -- Fire the callbacks

						index += (#possible_tag) -- Increase the index to avoid looping through the tag
						continue -- Skip to the next iteration
					elseif (end_tag == false) then -- If the tag is valid but does not have an end_tag in the configuration then:
						current_text ..= possible_tag -- Append it to current_text
						index += (#possible_tag) -- Increase the index to avoid looping through the tag
						continue -- Skip to the next iteration
					end
				elseif (current_character == "&") then -- Detecting Escape Characters:
					local possible_tag = string.match(final_text, "&.-;", index)
					if (check_if_valid_tag(possible_tag)) then -- If valid:
						current_text ..= possible_tag -- Append it to current_text
						index += (#possible_tag) -- Increase the index to avoid looping through the tag
						
						
						-- Doing this because this is an individual character:
						local actual_text = current_text -- The text that will be sent in the callbacks
						for i = 1, n_pile_up_table do -- Append all the piled up end tags to it
							actual_text ..= pile_up_table[i]
						end
						self.__on_text_updated:Fire(actual_text, final_text) -- Fire the callbacks
						
						FastWait(self.__interval) -- Wait for interval
						
						
						continue -- Skip to the next iteration
					end
				end
				
				-- Append the next character to current_text
				current_text ..= string.sub(final_text, index, index)
				
				local actual_text = current_text -- The text that will be sent in the callbacks
				for i = 1, n_pile_up_table do -- Append all the piled up end tags to it
					actual_text ..= pile_up_table[i]
				end
				self.__on_text_updated:Fire(actual_text, final_text) -- Fire the callbacks
				
				index += 1
				FastWait(self.__interval)
			end
			self.__running = false
			self.__on_typer_finished:Fire(final_text)
		else
			-- // CODE FOR PLAIN TEXT \\ --
			local current_text = ""
			
			local index = 1
			while ((index <= length) and (not self.__stop_signal)) do
				
				-- Pause loop
				if (self.__pause) then
					self.__running = false
					while (self.__pause) do
						RunService.Heartbeat:Wait()
					end
					self.__running = true
				end
				
				local current_character = string.sub(final_text, index, index)
				if (current_character == " ") then -- Ignore blank spaces
					current_text ..= current_character
					index += 1
					continue -- Skip to the next iteration
				end
				
				current_text = string.sub(final_text, 1, index)

				self.__on_text_updated:Fire(current_text, final_text)
				
				index += 1
				FastWait(self.__interval)
			end
			self.__running = false
			self.__on_typer_finished:Fire(final_text)
		end
	end

	if (not yield) then
		execute = coroutine.wrap(execute)
	end

	execute()

	return yield
end

-- Stop typing text
function type_writer_object_table:Stop()
	self.__pause = false
	self.__stop_signal = true
	while (self.__running) do
		RunService.Heartbeat:Wait()
	end
	return true
end

-- Change typing speed
function type_writer_object_table:AdjustSpeed(interval)
	self.__interval = interval
	return true
end

-- Pause typing
function type_writer_object_table:Pause()
	self.__pause = true
	while (self.__running) do
		RunService.Heartbeat:Wait()
	end
	return true
end

-- Unpause typing
function type_writer_object_table:Unpause()
	self.__pause = false
	while (not self.__running) do
		RunService.Heartbeat:Wait()
	end
	return true
end

-- Check if the object is currently typing
function type_writer_object_table:IsTyping()
	return self.__running
end

-- Destroy this whole object
function type_writer_object_table:Destroy()
	self.__pause = false
	self.__stop_signal = true
	self.__on_text_updated:Destroy()
	self.__on_typer_finished:Destroy()
	
	while (self.__running) do
		RunService.Heartbeat:Wait()
	end
	
	self = nil
	return nil
end

return main_type_writer_table
