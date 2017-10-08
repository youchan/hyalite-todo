class TodoItem
  include Hyalite::Component

  def handle_submit(event)
    val = @state.editText.strip
    if val
      @props[:onSave].call(val)
      set_state(editText: val)
    else
      @props[:onDestroy].call
    end
  end

  def handle_edit
    @props[:onEdit].call
    set_state(editText: @props[:todo].title)
  end

  def handle_key_down(event)
    if event.code === :Enter
      handle_submit(event)
    end
  end

  def handle_focus_out(event)
    set_state(editText: @props[:todo].title)
    @props[:onCancel].call(event)
  end

  def handle_change(event)
    if @props[:editing]
      set_state(editText: event.target.value)
    end
  end

  def initial_state
    { editText: @props[:todo].title }
  end

  after_update do |prev_props|
    if !prev_props[:editing] && @props[:editing]
      node = @refs[:editField]
      `node.native.focus()`
      `node.native.setSelectionRange(node.native.value.length, node.native.value.length)`
    end
  end

  def render
    li({ class: [ @props[:todo].completed ? 'completed' : '',
                                                @props[:editing] ? 'editing' : '' ].join },
      div({ class: "view" },
        input({
          class: "toggle",
          type: "checkbox",
          checked: @props[:todo].completed,
          onChange: @props[:onToggle]
        }),
        label({ onDoubleClick: method(:handle_edit) }, @props[:todo].title),
        button({ class: "destroy", onClick: @props[:onDestroy] })
      ),
      input({
        ref: "editField",
        class: "edit",
        value: @state.editText,
        onBlur: method(:handle_submit),
        onChange: method(:handle_change),
        onKeyDown: method(:handle_key_down),
        onFocusOut: method(:handle_focus_out)
      })
    )
  end
end
