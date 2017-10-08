class TodoFooter
  include Hyalite::Component

  def render
    active_todo_word = @props[:count] == 1 ? 'item' : 'items'

    if @props[:completedCount] > 0
      clear_button =
        button({
          class: "clear-completed",
          onClick: -> { @props[:onClearCompleted].call },
        }, "Clear completed")
    end

    now_showing = @props[:nowShowing]

    footer({ class: "footer" },
      span({ class: "todo-count" },
        strong(nil, @props[:count]),
        "#{active_todo_word} left"
      ),
      ul({ class: "filters" },
        li(nil,
          a({
            href: "#/",
            class: now_showing == :all ? 'selected' : ''
          }, "All")),
          #' '),
        li(nil,
          a({
            href: "#/active",
            class: now_showing == :active ? 'selected' : ''
          }, 'Active')),
          #' '),
        li(nil,
          a({
            href: "#/completed",
            class: now_showing == :completed ? 'selected' : ''
          }, "Completed"),
        ),
      ),
      clear_button
    )
  end
end
