function render(filename::String = tempname();
                filetype=:PNG,
                animation=false, transparent=false)
    # https://blender.stackexchange.com/a/149715
    render_context.film_transparent = transparent
    transparent && (render_context.image_settings.color_mode = "RGBA")

    render_context.use_file_extension = true
    render_context.filepath = filename
    render_context.image_settings.file_format = string(filetype)
    render_ops.render(animation=animation,
                      write_still=!animation)
end
