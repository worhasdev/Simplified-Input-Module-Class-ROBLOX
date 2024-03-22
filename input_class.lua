--[[
Author(s): Krish "worhas" Purgaus
Purpose: Handles inputs 
]]--


local input = {}

local uis = game:GetService("UserInputService")
local player = game:GetService("Players").LocalPlayer

local buttons = {
	{ Name = "flashlight", HoldInput = false },
	{ Name = "crouch", HoldInput = true },
	{ Name = "interact", HoldInput = false },
	{ Name = "sprint", HoldInput = false },
	{ Name = "em1", HoldInput = false},
	{ Name = "em2", HoldInput = false},
	{ Name = "em3", HoldInput = false},
}

local keyboard_bind = {
	[Enum.KeyCode.C] = "crouch",
	[Enum.KeyCode.E] = "interact",
	[Enum.KeyCode.T] = "em1",
	[Enum.KeyCode.Y] = "em2",
	[Enum.KeyCode.U] = "em3",
}

local gamepad_bind = {
	[Enum.KeyCode.ButtonR2] = "crouch",
	[Enum.KeyCode.ButtonX] = "interact",
	[Enum.KeyCode.ButtonY] = "em1",
	[Enum.KeyCode.ButtonL1] = "em2",
	[Enum.KeyCode.ButtonR3] = "em3",
}

local buttonEvents = {}

function input.Init()
	local holdInputState = {}

	local function isHoldInput(button)
		return button.HoldInput
	end

	local function getInputState(button)
		return holdInputState[button.Name] or false
	end

	local function setInputState(button, isPressed)
		holdInputState[button.Name] = isPressed
	end

	local function createButtonEvent(button)
		local buttonEvent = Instance.new("BindableEvent")
		buttonEvents[button.Name] = buttonEvent
		return buttonEvent
	end

	local function getButtonEvent(button)
		return buttonEvents[button.Name] or createButtonEvent(button)
	end

	local function updateButton(button, isPressed)
		if getInputState(button) ~= isPressed then
			setInputState(button, isPressed)
			local buttonEvent = getButtonEvent(button)
			buttonEvent:Fire(isPressed)
		end
	end

	local function onKeyDown(inputObject, isRepeat)
		if isRepeat then return end
		if inputObject.UserInputType == Enum.UserInputType.Keyboard then
			local key = inputObject.KeyCode
			local buttonName = keyboard_bind[key]
			if buttonName then
				local button = nil
				for _, btn in ipairs(buttons) do
					if btn.Name == buttonName then
						button = btn
						break
					end
				end
				if button then
					if isHoldInput(button) then
						updateButton(button, true)
					elseif not getInputState(button) then
						updateButton(button, true)
						updateButton(button, false)  -- Set the button state to false straight away
					end
				end
			end
		elseif inputObject.UserInputType == Enum.UserInputType.Gamepad1 then
			local key = inputObject.KeyCode
			local buttonName = gamepad_bind[key]
			if buttonName then
				local button = nil
				for _, btn in ipairs(buttons) do
					if btn.Name == buttonName then
						button = btn
						break
					end
				end
				if button then
					if isHoldInput(button) then
						updateButton(button, true)
					elseif not getInputState(button) then
						updateButton(button, true)
						updateButton(button, false)  -- Set the button state to false straight away
					end
				end
			end
		end
	end

	local function onKeyUp(inputObject)
		if inputObject.UserInputType == Enum.UserInputType.Keyboard then
			local key = inputObject.KeyCode
			local buttonName = keyboard_bind[key]
			if buttonName then
				local button = nil
				for _, btn in ipairs(buttons) do
					if btn.Name == buttonName then
						button = btn
						break
					end
				end
				if button then
					updateButton(button, false)
				end
			end
		elseif inputObject.UserInputType == Enum.UserInputType.Gamepad1 then
			local key = inputObject.KeyCode
			local buttonName = gamepad_bind[key]
			if buttonName then
				local button = nil
				for _, btn in ipairs(buttons) do
					if btn.Name == buttonName then
						button = btn
						break
					end
				end
				if button then
					updateButton(button, false)
				end
			end
		end
	end

	uis.InputBegan:Connect(onKeyDown)
	uis.InputEnded:Connect(onKeyUp)
end

function input.HasControls(self)
	return true
end

function input.GetButtonEvent(self, buttonName)
	local buttonEvent = buttonEvents[buttonName]
	if not buttonEvent then
		buttonEvent = Instance.new("BindableEvent")
		buttonEvents[buttonName] = buttonEvent
	end
	return buttonEvent
end

return input

