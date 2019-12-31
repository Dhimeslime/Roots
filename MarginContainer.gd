onready var number_label = $Bars/LifeBar/Count/Background/Number
onready var bar = $Bars/LifeBar/TextureProgress
onready var tween = $Tween

func _ready():
    var player_max_health = $"Player".max_health
    bar.max_value = player_max_health