using GeometryBasics
using CoordinateTransformations

# Clear all objects in the scene and delete all meshes
function clear_objects()
    length(data.meshes) == 0 && return
    object_ops.mode_set(mode="OBJECT")
    object_ops.select_by_type(; :type => "MESH")
    object_ops.delete(use_global = false)

    for m in data.meshes
        data.meshes.remove(m, do_unlink = true)
    end
end

function add(m::Mesh{3,T}, name,
             trf::Transformation=IdentityTransformation()) where T
    mesh = data.meshes.new("$(name)_mesh")
    object = data.objects.new("$(name)_obj", mesh)

    scene = context.scene
    scene.collection.objects.link(object)
    context.view_layer.objects.active = object
    # object.select = true

    verts = map(trf.(decompose(Point3{T}, m))) do v
        v[1],v[2],v[3]
    end

    # Need to transform normals properly
    norms = map(decompose(Normal(), m)) do n
        n[1],n[2],n[3]
    end

    # Should be able to use GLTriangleFace, instead of subtracting 1
    # manually.
    faces = map(decompose(TriangleFace{UInt32}, m)) do f
        f[1]-1,f[2]-1,f[3]-1
    end

    mesh.from_pydata(verts,
                       [],
                       faces)
    mesh.update()

    object
end
