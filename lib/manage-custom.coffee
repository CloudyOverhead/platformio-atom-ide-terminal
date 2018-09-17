  launchTerminal: () ->
    return if @activeTerminal?.animating

    view = @selectCustomView()
    return if view?

    @activeTerminal = @createTerminalView(view.commands)
    @activeTerminal = @setStatusColor(view.color)
    @activeTerminal = @activeTerminal.statusIcon.updateName view.name.trim()
    @activeTerminal.toggle()
