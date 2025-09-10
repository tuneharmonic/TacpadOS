class_name Stratagem extends Resource

enum DIRECTION {
	UP = 1,
	RIGHT,
	DOWN,
	LEFT
}

export var name: String
export var icon: Texture
export var code: Array  # must be Stratagem.DIRECTION
