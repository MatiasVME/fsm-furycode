# FSM FuryCode

![Licencia: MIT](https://img.shields.io/badge/Licencia-MIT-yellow.svg)
![Versión de Godot](https://img.shields.io/badge/Godot-4.6+-blue.svg)
![Tipo de Addon](https://img.shields.io/badge/Tipo-Biblioteca%20FSM-green.svg)

Un addon de Máquina de Estados Finitos (FSM) basado en nodos para Godot 4.6+ que proporciona una forma simple y visual de implementar máquinas de estados utilizando el sistema de nodos de Godot.

## 🎯 Características

- **Diseño Visual**: Crea máquinas de estados usando el sistema de nodos de Godot
- **Integración con el Editor**: Tipos de nodos personalizados con iconos distintivos
- **Seguridad de Tipos**: Tipado fuerte con clases `FSM_StateMachine` y `FSM_State`
- **Gestión de Procesos**: Habilitación/deshabilitación automática de las funciones de proceso de Godot
- **Sistema de Transiciones**: Transiciones configurables entre estados
- **Soporte de Depuración**: Capacidades de depuración incorporadas
- **Sistema de Señales**: Eventos para notificaciones de entrada/salida de estados
- **Sistema de Objetivos**: Controla cualquier objeto `Node2D` con el FSM

## 📦 Instalación

1. **Descarga el addon** o clona este repositorio
2. **Copia la carpeta `addons/fsm_furycode`** al directorio `addons/` de tu proyecto
3. **Habilita el addon** en Godot:
   - Ve a `Proyecto > Configuración del Proyecto > Complementos`
   - Busca "FSM-FuryCode" y habilítalo

## 🚀 Inicio Rápido

### Configuración Básica

1. **Crea un nodo StateMachine** en tu escena
2. **Añade un objetivo Node2D** (como un CharacterBody2D o Sprite2D)
3. **Asigna el objetivo** a la propiedad `target` de la StateMachine
4. **Añade nodos State** como hijos de la StateMachine
5. **Configura transiciones** estableciendo el array `transitions_names` de cada estado
6. **Establece el estado inicial** en la propiedad `initial_state` de la StateMachine

### Ejemplo de Código

```gdscript
# En el inspector del nodo StateMachine:
# - target: [Tu personaje Node2D]
# - initial_state: "idle"
# - debug_mode: true (opcional)

# En tus nodos State:
# - Nombre: "idle", "walk", "jump", etc.
# - transitions_names: ["walk", "jump"] (desde el estado idle)
# - transitions_names: ["idle", "jump"] (desde el estado walk)

# Transiciona a otro estado:
state_machine.transition_with_name("walk")

# Escucha cambios de estado:
state_machine.state_entered.connect(_on_state_entered)
state_machine.state_exited.connect(_on_state_exited)

func _on_state_entered(next_state: Node):
	print("Entró al estado: ", next_state.name)

func _on_state_exited(current_state: Node):
	print("Salió del estado: ", current_state.name)
```

## 📚 Referencia de API

### FSM_StateMachine

El nodo controlador principal de la máquina de estados.

#### Propiedades

- `Node2D target`: El nodo que controla este FSM
- `String initial_state`: Nombre del estado inicial
- `bool debug_mode`: Habilitar salida de depuración a la consola

#### Métodos

- `void transition_with_name(String state_name)`: Transiciona al estado por nombre
- `void transition_with_state(Node state)`: Transiciona al estado por instancia
- `Node get_state_by_name(String state_name)`: Obtiene la instancia del estado por nombre
- `void enable_all_process(bool enabled)`: Habilita/deshabilita todas las funciones de proceso

#### Señales

- `state_entered(Node next_state)`: Emitida al entrar a un nuevo estado
- `state_exited(Node current_state)`: Emitida al salir del estado actual

### FSM_State

Representa un estado individual en la máquina de estados.

#### Propiedades

- `PackedStringArray transitions_names`: Array de nombres de transiciones permitidas

#### Métodos

- `void enable_all_process(bool enabled)`: Habilita/deshabilita `_process`, `_physics_process`, `_input`, etc.

#### Auto-Referencias

- `state_machine`: Referencia al `FSM_StateMachine` padre
- `target`: Referencia al nodo objetivo del FSM

## 💡 Ejemplos de Uso

### FSM de Movimiento de Personaje

```gdscript
# Configuración del nodo StateMachine:
# target: CharacterBody2D
# initial_state: "idle"
# debug_mode: true

# Estado Idle:
# nombre: "idle"
# transitions_names: ["walk", "jump"]

extends FSM_State

func _ready():
	super._ready()
	# Inicialización específica del estado

func _physics_process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		state_machine.transition_with_name("jump")
	elif Input.is_action_pressed("ui_right") or Input.is_action_pressed("ui_left"):
		state_machine.transition_with_name("walk")

# Estado Walk:
# nombre: "walk"
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

# Estado Jump:
# nombre: "jump"
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

### FSM de Controlador de Animación

```gdscript
# StateMachine de Animación
# target: AnimatedSprite2D

# Estado de Animación Idle:
extends FSM_State

func _enter_state():
	target.play("idle")

func _exit_state():
	target.stop()

# Estado de Animación Walk:
extends FSM_State

func _enter_state():
	target.play("walk")

func _exit_state():
	target.stop()
```

## 🔧 Características Avanzadas

### Modo Depuración

Habilita `debug_mode` en la StateMachine para obtener salida detallada en la consola:

```
[FSM] Transicionando de 'idle' a 'walk'
[FSM] Estado 'walk' entró
[FSM] Estado 'idle' salió
```

### Gestión de Procesos

FSM State gestiona automáticamente las funciones de proceso de Godot:

- **Estado Activo**: Todas las funciones de proceso (`_process`, `_physics_process`, `_input`, etc.) están habilitadas
- **Estado Inactivo**: Todas las funciones de proceso están deshabilitadas para mejorar el rendimiento
- **Control Manual**: Usa `enable_all_process(enabled)` para anular

### Lógica de Estado Personalizada

Sobrescribe estos métodos en tus clases State:

```gdscript
extends FSM_State

func _enter_state():
	# Llamado cuando el estado se vuelve activo
	pass

func _exit_state():
	# Llamado cuando el estado se vuelve inactivo
	pass

func _process(delta):
	# Llamado cada frame cuando está activo
	pass

func _physics_process(delta):
	# Llamado cada frame de física cuando está activo
	pass
```

## 🧪 Pruebas

Este proyecto incluye pruebas unitarias completas utilizando el framework GUT (Godot Unit Testing).

### Ejecutar Pruebas

1. Instala y habilita el addon GUT (incluido en este repositorio)
2. Abre la escena de pruebas: `addons/fsm_furycode/tests/test_runner.tscn`
3. Haz clic en "Run Tests" en la interfaz de GUT
4. Ve los resultados en el panel de GUT

### Cobertura de Pruebas

- ✅ Inicialización y configuración del estado
- ✅ Configuración y gestión de la StateMachine
- ✅ Transiciones de estado y validación
- ✅ Emisión y manejo de señales
- ✅ Gestión de procesos
- ✅ Manejo de errores y casos límite
- ✅ Flujos de trabajo de integración

## 🤝 Contribuir

1. Fork el repositorio
2. Crea una rama de característica (`git checkout -b feature/característica-asombrosa`)
3. Commitea tus cambios (`git commit -m 'Añadir característica asombrosa'`)
4. Push a la rama (`git push origin feature/característica-asombrosa`)
5. Abre un Pull Request

### Guías de Desarrollo

- Sigue el estilo de código y convenciones de Godot
- Añade pruebas unitarias para nuevas características
- Actualiza la documentación para cambios en la API
- Asegúrate de que todas las pruebas pasen antes de enviar

## 📄 Licencia

Este proyecto está licenciado bajo la Licencia MIT - ve el archivo [LICENSE](LICENSE) para detalles.

## 👥 Autor

**Matías Muñoz Espinoza (FuryCode)**

## 🙏 Agradecimientos

- Godot Engine por el increíble framework de desarrollo de juegos
- GUT (Godot Unit Testing) por el framework de pruebas
- La comunidad de Godot por inspiración y retroalimentación

---

**FSM FuryCode** - ¡Haciendo las máquinas de estados simples y visuales en Godot! 🎮✨
