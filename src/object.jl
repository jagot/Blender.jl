# Clear all objects in the scene and delete all meshes
function clear_objects!()
    length(data.meshes) == 0 && return
    object_ops.mode_set(mode="OBJECT")
    object_ops.select_by_type(; :type => "MESH")
    object_ops.delete(use_global = false)

    for m in data.meshes
        data.meshes.remove(m, do_unlink = true)
    end
end

# https://blender.stackexchange.com/a/91687
function smooth!(ob)
    for f in ob.data.polygons
        f.use_smooth = true
    end
end

function add_object!(name::String, vertices, normals, faces; smooth=false)
    mesh = data.meshes.new("$(name)_mesh")
    object = data.objects.new("$(name)_obj", mesh)

    scene = context.scene
    scene.collection.objects.link(object)
    context.view_layer.objects.active = object
    # object.select = true

    facesm1 = map(f -> f .- 1, faces)

    mesh.from_pydata(vertices,
                     [],
                     facesm1)
    mesh.update()

    smooth && smooth!(object)
    object
end

function add_object!(name::String, m::Mesh{3,T};
                     trf::Transformation=IdentityTransformation(),
                     kwargs...) where T
    verts = map(trf.(decompose(Point3{T}, m))) do v
        v[1],v[2],v[3]
    end

    # Need to transform normals properly
    norms = map(decompose(Normal(), m)) do n
        n[1],n[2],n[3]
    end

    faces = map(decompose(TriangleFace{UInt32}, m)) do f
        f[1],f[2],f[3]
    end

    add_object!(name, verts, norms, faces; kwargs...)
end

function add_object!(name::String, p::GeometryBasics.GeometryPrimitive;
                     nvertices=24, kwargs...)
    m = Mesh(collect(coordinates(p, nvertices)),
             collect(faces(p, nvertices)))
    add_object!(name, m; kwargs...)
end

setcolor!(o, c::Colorant) =
    o.color = (red(c), green(c), blue(c), alpha(c))

function vertex_colors!(fun::Function, ob)
    # https://blender.stackexchange.com/a/911
    mesh = ob.data
    isempty(mesh.vertex_colors) && mesh.vertex_colors.new()
    cl = mesh.vertex_colors.active
    for (i,p) in enumerate(mesh.polygons)
        for (j,vi) in zip(p.loop_indices,p.vertices)
            setcolor!(cl.data[j+1], fun(vi+1))
        end
    end
end

function append_material!(ob, mat; activate=true)
    mesh = ob.data
    mesh.materials.append(mat)
    if activate
        ob.active_material_index = length(mesh.materials)-1
    end
end

export clear_objects!, smooth!, add_object!,
    vertex_colors!, append_material!
