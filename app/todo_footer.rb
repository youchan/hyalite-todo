class TodoFooter
  include Hyalite::Component

  def render
    active_todo_word = @props[:count] == 1 ? 'item' : 'items'

    if @props[:completedCount] > 0
      clear_button =
        button({
          className: "clear-completed",
          onClick: -> { @props[:onClearCompleted].call },
        }, "Clear completed")
    end

    now_showing = @props[:nowShowing]

    footer({ className: "footer" },
      span({ className: "todo-count" },
        strong(nil, @props[:count]),
        "#{active_todo_word} left"
      ),
      ul({ className: "filters" },
        li(nil,
          a({
            href: "#/",
            className: now_showing == :all ? 'selected' : ''
          }, "All")),
          #' '),
        li(nil,
          a({
            href: "#/active",
            className: now_showing == :active ? 'selected' : ''
          }, 'Active')),
          #' '),
        li(nil,
          a({
            href: "#/completed",
            className: now_showing == :completed ? 'selected' : ''
          }, "Completed"),
        ),
      ),
      clear_button
    )
  end
end
