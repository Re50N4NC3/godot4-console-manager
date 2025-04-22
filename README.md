# godot4-console-manager
Self contained console manager with custom commands and UI.

Allows to test and execute functions by calling them through registered names. Supports methods with simple arguments.

## Set up
1. Copy `Console` directory anywhere in your project.
1. Add `console_manager.gd` as a global singleton and name it `console_manager`.
1. Attach `Console.tscn` to any scene where you want to have a console, or also spawn it as a singleton to have console available everywhere.

Shown UI is just an example, scripts are be separated enough to use them on their own with custom made UI setup.

## ConsoleUi Visual settings
Here is the list of useful visual properties and how to set them.

### PanelContainer, sizing and scaling
`PanelContainer` has minimum sizing, you can change it if needed or resize the panel manually.
This panel also can be changed to something more fitting like grid container or set its mode to `Fill Horizontal`.

### ConsoleInput and text color
From `ConsoleInput` node you can set up visual settings like text colors for specific message types and max history count.

### Anchor Position
To change position use `Anchors Preset` property inside `PanelContainer`.

### Content fitting (input box movement on command execution)
When changing anchor position to top there are two options to keep input box in place:
	1. Disable content fitting inside `ConsoleLog`, `Fit Content = false`, it will cause logs to always stay the same size.
	1. Move `ConsoleInput` in hierarchy tree above the `ConsoleLog`, it will cause logs to expand downwards.
