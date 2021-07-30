using PyCall

const bpy = PyNULL()

const context = PyNULL()
const data = PyNULL()

const object_ops = PyNULL()
const object_context = PyNULL()

const render_ops = PyNULL()
const render_context = PyNULL()

function __init__()
    copy!(bpy, pyimport("bpy"))

    copy!(context, bpy.context)
    copy!(data, bpy.data)

    copy!(object_ops, bpy.ops.object)
    copy!(object_context, context.scene.objects)

    copy!(render_ops, bpy.ops.render)
    copy!(render_context, context.scene.render)
end
