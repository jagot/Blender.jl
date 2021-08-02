function lookat!(ob::PyObject; camera=nothing,
                 track_axis="TRACK_NEGATIVE_Z",
                 up_axis="UP_Y")
    if isnothing(camera)
        camera = context.scene.camera
    end

    # https://blender.stackexchange.com/a/16349
    # https://blender.stackexchange.com/a/176300
    ttc = camera.constraints.new(type="TRACK_TO")
    println(ttc)
    println(ob)
    ttc.target = ob
    ttc.track_axis = track_axis
    ttc.up_axis = up_axis
end

function lookat!(loc::Point3; kwargs...)
    # We cheat a bit by adding an empty object to look at
    bpy.ops.object.add(location=loc)
    lookat!(ob; kwargs...)
end

export lookat!
