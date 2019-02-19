extends RigidBody2D

func _on_Area2D_body_entered(body):
    if body.is_network_master():
        body.rpc("add_point")
        rpc("pickup")
        body.add_point()
        pickup()

remote func pickup():
    queue_free()