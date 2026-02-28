# FSM FuryCode

![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)
![Godot Version](https://img.shields.io/badge/Godot-4.6+-blue.svg)
![Addon Type](https://img.shields.io/badge/Type-FSM%20Library-green.svg)

A node-based Finite State Machine (FSM) addon for Godot 4.6+ that provides a simple, visual way to implement state machines using Godot's node system.

## 🎯 Features

- **Visual Design**: Create state machines using Godot's node system
- **Editor Integration**: Custom node types with distinctive icons
- **Type Safety**: Strong typing with `FSM_StateMachine` and `FSM_State` classes
- **Process Management**: Automatic enabling/disabling of Godot process functions
- **Transition System**: Configurable allowed transitions between states
- **Debug Support**: Built-in debugging capabilities
- **Signal System**: Events for state enter/exit notifications
- **Target System**: Control any `Node2D` object with the FSM

## 📦 Installation

1. **Download the addon** or clone this repository
2. **Copy the `addons/fsm_furycode` folder** to your project's `addons/` directory
3. **Enable the addon** in Godot:
   - Go to `Project > Project Settings > Plugins`
   - Find "FSM-FuryCode" and enable it

## 🚀 Quick Start

### Basic Setup

1. **Create a StateMachine node** in your scene
2. **Add a target Node2D** (like a CharacterBody2D or Sprite2D)
3. **Assign the target** to the StateMachine's `target` property
4. **Add State nodes** as children of the StateMachine
5. **Configure transitions** by setting each state's `transitions_names` array
6. **Set initial state** in the StateMachine's `initial_state` property

### Example Code

```gdscript
# In your StateMachine node inspector:
# - target: [Your Node2D character]
# - initial_state: "idle"
# - debug_mode: true (optional)

# In your State nodes:
# - Name: "idle", "walk", "jump", etc.
# - transitions_names: ["walk", "jump"] (from idle state)
# - transitions_names: ["idle", "jump"] (from walk state)

# Transition to another state:
state_machine.transition_with_name("walk")

# Listen to state changes:
state_machine.state_entered.connect(_on_state_entered)
state_machine.state_exited.connect(_on_state_exited)

func _on_state_entered(next_state: Node):
    print("Entered state: ", next_state.name)

func _on_state_exited(current_state: Node):
    print("Exited state: ", current_state.name)
```

## 📚 API Reference

### FSM_StateMachine

The main controller node for the state machine.

#### Properties

- `Node2D target`: The node that this FSM controls
- `String initial_state`: Name of the starting state
- `bool debug_mode`: Enable debug output to console

#### Methods

- `void transition_with_name(String state_name)`: Transition to state by name
- `void transition_with_state(Node state)`: Transition to state instance
- `Node get_state_by_name(String state_name)`: Get state instance by name
- `void enable_all_process(bool enabled)`: Enable/disable all process functions

#### Signals

- `state_entered(Node next_state)`: Emitted when entering a new state
- `state_exited(Node current_state)`: Emitted when exiting the current state

### FSM_State

Represents an individual state in the state machine.

#### Properties

- `PackedStringArray transitions_names`: Array of allowed transition target names

#### Methods

- `void enable_all_process(bool enabled)`: Enable/disable `_process`, `_physics_process`, `_input`, etc.

#### Auto-References

- `state_machine`: Reference to parent `FSM_StateMachine`
- `target`: Reference to the FSM's target node

## 💡 Usage Examples

### Character Movement FSM

```gdscript
# StateMachine node setup:
# target: CharacterBody2D
# initial_state: "idle"
# debug_mode: true

# Idle State:
# name: "idle"
# transitions_names: ["walk", "jump"]

extends FSM_State

func _ready():
    super._ready()
    # State-specific initialization

func _physics_process(delta):
    if Input.is_action_just_pressed("ui_accept"):
        state_machine.transition_with_name("jump")
    elif Input.is_action_pressed("ui_right") or Input.is_action_pressed("ui_left"):
        state_machine.transition_with_name("walk")

# Walk State:
# name: "walk"
# transitions_names: ["idle", "jump"]

extends FSM_State

func _physics_process(delta):
    var direction = 0
    if Input.is_action_pressed("ui_right"):
        direction = 1
    elif Input.is_action_pressed("ui_left"):
        direction = -1
    else:
        state_machine.transition_with_name("idle")
        return
    
    target.velocity.x = direction * 200
    target.move_and_slide()
    
    if Input.is_action_just_pressed("ui_accept"):
        state_machine.transition_with_name("jump")

# Jump State:
# name: "jump"
# transitions_names: ["idle", "walk"]

extends FSM_State

var jump_velocity = -400

func _enter_state():
    target.velocity.y = jump_velocity

func _physics_process(delta):
    if not target.is_on_floor():
        target.velocity.y += target.gravity * delta
    else:
        if Input.is_action_pressed("ui_right") or Input.is_action_pressed("ui_left"):
            state_machine.transition_with_name("walk")
        else:
            state_machine.transition_with_name("idle")
    
    var direction = 0
    if Input.is_action_pressed("ui_right"):
        direction = 1
    elif Input.is_action_pressed("ui_left"):
        direction = -1
    
    target.velocity.x = direction * 200
    target.move_and_slide()
```

### Animation Controller FSM

```gdscript
# Animation StateMachine
# target: AnimatedSprite2D

# Idle Animation State:
extends FSM_State

func _enter_state():
    target.play("idle")

func _exit_state():
    target.stop()

# Walk Animation State:
extends FSM_State

func _enter_state():
    target.play("walk")

func _exit_state():
    target.stop()
```

## 🔧 Advanced Features

### Debug Mode

Enable `debug_mode` on the StateMachine to get detailed console output:

```
[FSM] Transitioning from 'idle' to 'walk'
[FSM] State 'walk' entered
[FSM] State 'idle' exited
```

### Process Management

FSM State automatically manages Godot process functions:

- **Active State**: All process functions (`_process`, `_physics_process`, `_input`, etc.) are enabled
- **Inactive State**: All process functions are disabled for performance
- **Manual Control**: Use `enable_all_process(enabled)` to override

### Custom State Logic

Override these methods in your State classes:

```gdscript
extends FSM_State

func _enter_state():
    # Called when state becomes active
    pass

func _exit_state():
    # Called when state becomes inactive
    pass

func _process(delta):
    # Called every frame when active
    pass

func _physics_process(delta):
    # Called every physics frame when active
    pass
```

## 🧪 Testing

This project includes comprehensive unit tests using the GUT (Godot Unit Testing) framework.

### Running Tests

1. Install and enable the GUT addon (included in this repository)
2. Open the test scene: `addons/fsm_furycode/tests/test_runner.tscn`
3. Click "Run Tests" in the GUT interface
4. View results in the GUT panel

### Test Coverage

- ✅ State initialization and configuration
- ✅ StateMachine setup and management
- ✅ State transitions and validation
- ✅ Signal emission and handling
- ✅ Process management
- ✅ Error handling and edge cases
- ✅ Integration workflows

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Development Guidelines

- Follow Godot's coding style and conventions
- Add unit tests for new features
- Update documentation for API changes
- Ensure all tests pass before submitting

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👥 Author

**Matías Muñoz Espinoza (FuryCode)**

## 🙏 Acknowledgments

- Godot Engine for the amazing game development framework
- GUT (Godot Unit Testing) for the testing framework
- The Godot community for inspiration and feedback

---

**FSM FuryCode** - Making state machines simple and visual in Godot! 🎮✨