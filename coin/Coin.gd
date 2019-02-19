extends RigidBody2D

slave var slave_position = Vector2()

func _on_Area2D_body_entered(body):
    if body.is_network_master():
        body.rpc("add_point")
        body.add_point()
    
    queue_free()