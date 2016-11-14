object_ops = bpy.ops[:object]

# Clear all objects in the scene and delete all meshes
function clear_objects()
    length(data[:meshes]) == 0 && return
    object_ops[:mode_set](mode="OBJECT")
    object_ops[:select_by_type](; :type => "MESH")
    object_ops[:delete](use_global = false)

    for m in data[:meshes]
        data[:meshes][:remove](m, do_unlink = true)
    end
end
