require 'hyalite'
require 'opal-router'
require 'browser/interval'
require_relative 'todo_model'
require_relative 'todo_item'
require_relative 'todo_footer'

module App
  def self.render
    Hyalite.render(TodoApp.el({model: model}), $document['.todoapp'])
  end

  def self.model
    @model ||= TodoModel.new
  end
end

class TodoApp
  include Hyalite::Component

  state :nowShowing, :all
  state :editing, nil
  state :newTodo, ''

  after_mount do
    router = Router.new
    router.route('/') { set_state({nowShowing: :all}) }
    router.route('/active') { set_state({nowShowing: :active}) }
    router.route('/completed') { set_state({nowShowing: :completed}) }
  end

  def handle_new_todo_key_down(event)
    return unless event.code == :Enter

    event.prevent_default

    val = @state.newTodo.strip

    if val
      @props[:model] << val
      set_state(newTodo: '')
    end
  end

  def handle_change(event)
    set_state(newTodo: event.target.value)
  end

  def save(todo, text)
    @props[:model].save(todo, text)
    set_state(editing: nil)
  end

  def render
    todos = @props[:model].todos

    shown_todos = todos.select do |todo|
      case @state.nowShowing
      when :active
        !todo.completed
      when :completed
        todo.completed
      else
        true
      end
    end

    todo_items = shown_todos.map do |todo|
      TodoItem.el({
        key: todo.id,
        todo: todo,
        onToggle: -> { @props[:model].toggle(todo) },
        onDestroy: -> { @props[:model].destroy(todo) },
        onEdit: -> { set_state(editing: todo.id) },
        editing: @state.editing == todo.id,
        onSave: -> (text) { save(todo, text) },
        onCancel: -> { set_state(editing: nil) }
      })
    end

    completed_count = todos.count(&:completed)
    active_todo_count = todos.length - completed_count

    if todos.any?
      main =
        section({ class: "main" },
          input({
            class: "toggle-all",
            type: "checkbox",
            onChange: -> (event) { @props[:model].toggle_all(event.target.checked?) },
            checked: active_todo_count == 0
          }),
          ul({ class: "todo-list" }, todo_items)
        )

      footer =
        TodoFooter.el({
          count: active_todo_count,
          completedCount: completed_count,
          nowShowing: @state.nowShowing,
          onClearCompleted: -> { @props[:model].clear_completed }
        })
    end

    div(nil,
      header({class: 'header'},
        h1(nil, "todos"),
        input({
          class: 'new-todo',
          placeholder: 'What needs to be done?',
          autofocus: true,
          onKeyDown: method(:handle_new_todo_key_down),
          onChange: method(:handle_change),
          value: @state.newTodo
        })),
      main,
      footer)
  end
end

$document.ready do
  App.model.subscribe do
    App.render
  end

  App.render
end
