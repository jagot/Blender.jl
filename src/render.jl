render_ops = bpy.ops[:render]
render_context = context[:scene][:render]

function render(filename::String = tempname(),
                filetype = :PNG,
                animation = false)
    render_context[:use_file_extension] = true
    render_context[:filepath] = filename
    render_context[:image_settings][:file_format] = string(filetype)
    render_ops[:render](animation=animation,
                        write_still=!animation)
end
