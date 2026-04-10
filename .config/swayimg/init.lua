swayimg.gallery.on_key("Shift+c", function()
    local image = swayimg.gallery.get_image()
    local path = image.path
    -- Use printf and quote the argument safely
    os.execute(string.format("printf '%%s' %q | wl-copy", path))
end)

swayimg.viewer.on_key("Shift+c", function()
    local image = swayimg.viewer.get_image()
    local path = image.path
    -- Use printf and quote the argument safely
    os.execute(string.format("printf '%%s' %q | wl-copy", path))
end)
