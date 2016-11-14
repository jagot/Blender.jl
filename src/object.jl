using GeometryTypes
using AffineTransforms

object_ops = bpy.ops[:object]
object_context = context[:scene][:objects]

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

function add{M<:HomogenousMesh}(m::M, name::String,
                                trf::AffineTransform{Float32,3} = tformeye(Float32, 3))
    mesh = data[:meshes][:new]("$(name)_mesh")
    object = data[:objects][:new]("$(name)_obj", mesh)
    object_context[:link](object)
    object_context[:active] = object
    object[:select] = true

    verts = map(m.vertices) do v
        v = trf*[v...] # More efficient way?
        v[1],v[2],v[3]
    end

    # Need to transform normals properly
    norms = map(m.normals) do n
        n[1],n[2],n[3]
    end

    faces = map(decompose(Face{3,UInt32,-1}, m.faces)) do f
        f[1],f[2],f[3]
    end

    mesh[:from_pydata](verts,
                       [],
                       faces)
    mesh[:update]()
    object
end
