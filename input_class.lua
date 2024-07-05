--[[

Author(s): Krish "worhas" Purgaus 
Directory: N/A

Licensing:
GNU GENERAL PUBLIC LICENSE
Version 3, 29 June 2007
The rights to this software are held by Krish Purgaus,  and it is released under the GNU General Public License (GPL), Version 3. This program is free software: you can redistribute it and/or modify it under the terms of the GNU GPL as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
You should have received a copy of the GNU General Public License along with this program. If not, see <http://www.gnu.org/licenses/>.
The rights and ownership of this software remain with Krish Purgaus. You are granted the freedom to use, modify, and share the software under the terms of the GPL. Any derivative works must also be licensed under the GPL, ensuring that future users maintain the same freedoms.
- Krish Purgaus
- March 30th, 2024

]]--

local input = {}

local uis = game:GetService("UserInputService")
local player = game:GetService("Players").LocalPlayer

local buttons = {
	{ Name = "ability1", HoldInput = false },
	{ Name = "ability2", HoldInput = false },
	{ Name = "ability3", HoldInput = false },
	{ Name = "ability4", HoldInput = false },
}

local keyboard_bind = {
	[Enum.KeyCode.One] = "ability1",
	[Enum.KeyCode.Two] = "ability2",
	[Enum.KeyCode.Three] = "ability3",
	[Enum.KeyCode.Four] = "ability4",
}

local gamepad_bind = {
	[Enum.KeyCode.ButtonR2] = "ability1",
	[Enum.KeyCode.ButtonX] = "ability2",
	[Enum.KeyCode.ButtonY] = "ability3",
	[Enum.KeyCode.ButtonL1] = "ability4",
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
