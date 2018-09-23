{TextEditorView, SelectListView, View} = require "atom-space-pen-views"

module.exports =
class ManageCustomDialog extends View
  @content: ->
    @div class: 'platformio-ide-terminal-dialog', =>
      @label "Custom Terminals", class: 'icon-pencil', outlet: 'promptText'
      @subview 'customList', new CustomSelectList this
      @label 'Escape (Esc) to exit', style: 'width: 25%;'
      @label 'Right click to launch', style: 'width: 25%; text-align: center;'
      @label 'Left click to edit', style: 'width: 25%; text-align: right;'

  config = []

  initialize: (@statusBar) ->
    @attach()
    atom.commands.add 'atom-text-editor',
      'core:cancel': => @close()

    @pullConfig()
    @customList.setItems @config

  attach: ->
    @panel = atom.workspace.addModalPanel(item: @element)
    @element.focus()

  confirm: (item) ->
    @config = @getItems()
    @pushConfig()
    @statusBar.launchCustomTerminal(item)
    @close()

  close: ->
    panelToDestroy = @panel
    @panel = null
    panelToDestroy?.destroy()
    atom.workspace.getActivePane().activate()

  pullConfig: ->
    @config = atom.config.get "platformio-ide-terminal.customViews"

  pushConfig: ->
    atom.config.set "platformio-ide-terminal.customView", @config

  editEntry: -> new Dialog "Insert New Value", "icon-keyboard"


class CustomSelectList extends SelectListView
  initialize: (@parentView) ->

  viewForItem: (item) ->
    icon = @icon(item.color)
    commands = "<li>" + item.commands.join("</li><li>") + "</li>"
    """
    <li>
      <b>#{icon} #{item.name} (shortcut: #{item.shortcut})</b><br>
      Commands ran on initialization:
      <ul><tt>
        #{commands}
      </tt></ul>
    <li>
    """

  confirmed: (item) -> @parentView.confirm(item)

  icon: (color) ->
    if color
      color = atom.config.get("platformio-ide-terminal.iconColors.#{color}")
      color = color.toRGBAString()
    return "<span class='icon icon-terminal' color=#{color}></span>"
