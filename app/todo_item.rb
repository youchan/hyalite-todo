class TodoItem
  include Hyalite::Component
  include Hyalite::Component::ShortHand

  ESCAPE_KEY = 27
  ENTER_KEY = 13

  def handle_submit(event)
    val = @state[:editText].strip
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
    if event.code == ESCAPE_KEY
      set_state(editText: @props[:todo].title)
      @props[:onCancel].call(event)
    elsif event.code === ENTER_KEY
      handle_submit(event)
    end
  end

  def handle_change(event)
    if @props[:editing]
      set_state(editText: event.target.value)
    end
  end

  def get_initial_state
    { editText: @props[:todo].title }
  end

  def component_did_update(prev_props)
    if !prev_props[:editing] && @props[:editing]
      node = Hyalite.find_dom_node(@refs[:editField])
      `node.native.focus()`
      `node.native.setSelectionRange(node.native.value.length, node.native.value.length)`
    end
  end

  def render
    li({ className: [ @props[:todo].completed ? 'completed' : '',
                                                @props[:editing] ? 'editing' : '' ].join },
      div({ className: "view" },
        input({
          className: "toggle",
          type: "checkbox",
          checked: @props[:todo].completed,
          onChange: -> (event) { @props[:onToggle].call(event) }
        }),
        label({ onDoubleClick: -> { handle_edit } }, @props[:todo].title),
        button({ className: "destroy", onClick: -> (event) { @props[:onDestroy].call(event) } })
      ),
      input({
        ref: "editField",
        className: "edit",
        value: @state[:editText],
        onBlur: -> (event) { handle_submit(event) },
        onChange: -> (event) { handle_change(event) },
        onKeyDown: -> (event) { handle_key_down(event) }
      })
    )
  end
end
