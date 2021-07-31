function new_material(name::String; use_nodes=false)
    mat = data.materials.new(name=name)
    mat.use_nodes = use_nodes
    mat
end

function connections(node)
    println("Node \"$(node.name)\"")
    println(node)
    indices = 1:max(length(node.inputs),length(node.outputs))
    inames = vcat([i.name for i in node.inputs], fill("", indices[end]-length(node.inputs)))
    onames = vcat([o.name for o in node.outputs], fill("", indices[end]-length(node.outputs)))
    pretty_table(hcat(indices, inames, onames),
                 header=["#", "Input", "Output"],
                 alignment=[:r,:l,:l],
                 vlines=[1], hlines=[1])
end

function find_input(o, name)
    i = findfirst(i -> o.inputs[i].name == name, 1:length(o.inputs))
    isnothing(i) && error("No such input $(name)")
    o.inputs[i]
end

function find_output(o, name)
    i = findfirst(i -> o.outputs[i].name == name, 1:length(o.outputs))
    isnothing(i) && error("No such output $(name)")
    o.outputs[i]
end

function set_input!(o, name, value)
    find_input(o, name).default_value = value
end


export new_material, connections,
    find_input, find_output, set_input!
