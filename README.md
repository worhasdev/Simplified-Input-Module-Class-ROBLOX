# Simplified Input Class: ROBLOX
**A ROBLOX class that aims to simplify how inputs are used and manipulated across ROBLOX games.**

## What is this class about?
A flexible tool, the Simplified Input Module/Class for ROBLOX is made to simplify user input management. By utilizing OOP principles, bindable events, and schemas, this module provides a user-friendly and adaptable approach to managing inputs on multiple platforms.

Fundamentally, the module uses input tables and bindable events to effectively record user inputs such keystrokes, mouse clicks, and touch gestures. Developers may simply run functions to particular input events and carry out matching actions by using bindable events, which improves the responsiveness and interactivity of games, efficiently and performantly.

One of the key features of this module is its support for held inputs, allowing developers to seamlessly detect and respond to prolonged key presses or button holds. This functionality is crucial for implementing actions that require sustained input, such as character movement.

Additionally, the module is made to be compatible with multiple platforms, guaranteeing reliable input processing from various devices and input techniques. Regardless of whether users are utilizing a game controller or a keyboard and mouse, the module dynamically adjusts to provide a smooth gaming experience on all platforms.

## Documentation

***Example for non-held inputs***
```lua
local input_class = ([ENTER DIRECTORY PATH FOR INPUT CLASS])
local print_input = input_class:GetButtonEvent("printer_input")

print_input.Event:Connect(function(isPressed)
    if isPressed then
        print("I am being pressed!")
    end
end)
```

***Example for held inputs***
```lua
local input_class = ([ENTER DIRECTORY PATH FOR INPUT CLASS])
local print_input2 = input_class:GetButtonEvent("printer_input2")
print_input2.Event:Connect(function(isPressed)
    if isPressed then
        print("I am currently held down!")
    else
        print("I have been released!")
end)
```
