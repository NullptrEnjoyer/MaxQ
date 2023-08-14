extends IndependentPhysicsSolver2D

@onready var B1START:Line2D = $B1START
@onready var B1END:Line2D = $B1END
@onready var B2START:Line2D = $B2START
@onready var B2END:Line2D = $B2END

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	B1START.clear_points()
	B1END.clear_points()
	B2START.clear_points()
	B2END.clear_points()
	
	B1START.points = REMOVEME_getbody1start()
	B1END.points = REMOVEME_getbody1end()
	B2START.points = REMOVEME_getbody2start()
	B2END.points = REMOVEME_getbody2end()
	
