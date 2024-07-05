--[[
Author(s): Krish "worhas" Purgaus 
]]--

local input = {}

local uis = game:GetService("UserInputService")
local player = game:GetService("Players").LocalPlayer

local buttons = {
	{ Name = "ability1", HoldInput = false },
	{ Name = "ability2", HoldInput = false },
	{ Name = "ability3", HoldInput = false },
	{ Name = "ability4", HoldInput = false },
	{ Name = "special", HoldInput = false},
	{ Name = "sprint", HoldInput = true},
	{ Name = "block", HoldInput = false},
	{ Name = "dash", HoldInput = false},
}

local keyboard_bind = {
	[Enum.KeyCode.One] = "ability1",
	[Enum.KeyCode.Two] = "ability2",
	[Enum.KeyCode.Three] = "ability3",
	[Enum.KeyCode.Four] = "ability4",
	[Enum.KeyCode.E] = "special",
	[Enum.KeyCode.LeftShift] = "sprint",
	[Enum.KeyCode.F] = "block",
	[Enum.KeyCode.Q] = "dash",
}

local gamepad_bind = {
	[Enum.KeyCode.ButtonR2] = "ability1",
	[Enum.KeyCode.ButtonX] = "ability2",
	[Enum.KeyCode.ButtonY] = "ability3",
	[Enum.KeyCode.ButtonL1] = "ability4",
	[Enum.KeyCode.ButtonR3] = "special",
	[Enum.KeyCode.ButtonR1] = "sprint",
	[Enum.KeyCode.ButtonB] = "block",
	[Enum.KeyCode.ButtonL3] = "dash",
}

local buttonEvents = {}
local holdInputState = {}

function input.Init()
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
		local buttonName = nil
		if inputObject.UserInputType == Enum.UserInputType.Keyboard then
			buttonName = keyboard_bind[inputObject.KeyCode]
		elseif inputObject.UserInputType == Enum.UserInputType.Gamepad1 then
			buttonName = gamepad_bind[inputObject.KeyCode]
		end
		if buttonName then
			for _, button in ipairs(buttons) do
				if button.Name == buttonName then
					if isHoldInput(button) or not getInputState(button) then
						updateButton(button, true)
					end
					break
				end
			end
		end
	end

	local function onKeyUp(inputObject)
		local buttonName = nil
		if inputObject.UserInputType == Enum.UserInputType.Keyboard then
			buttonName = keyboard_bind[inputObject.KeyCode]
		elseif inputObject.UserInputType == Enum.UserInputType.Gamepad1 then
			buttonName = gamepad_bind[inputObject.KeyCode]
		end
		if buttonName then
			for _, button in ipairs(buttons) do
				if button.Name == buttonName then
					if isHoldInput(button) then
						updateButton(button, false)
					else
						setInputState(button, false)
					end
					break
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

function input.IsInputHeld(buttonName)
	return holdInputState[buttonName] or false
end

return input
