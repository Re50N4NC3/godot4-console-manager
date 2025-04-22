# godot4-console-manager
Self contained console manager with custom commands and UI

## Set up
1. Copy `Console` directory anywhere in your project.
1. Add `console_manager.gd` as a global singleton and name it `console_manager`.
1. Attach `Console.tscn` to your main camera.


## ConsoleUi Visual settings
Here is the list of useful visual properties and how to set them.

### Position
To change position use `Anchors Preset` property inside `PanelContainer`.

### Content fitting (input box movement on command execution)
When changing anchor position to top there are two options to keep input box in place:
	1. Disable content fitting inside `ConsoleLog`, `Fit Content = false`, it will cause logs to always stay the same size.
	1. Move `ConsoleInput` in hierarchy tree above the `ConsoleLog`, it will cause logs to expand downwards.
