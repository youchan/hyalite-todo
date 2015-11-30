require 'securerandom'

class TodoModel
  attr_reader :todos

  Item = Struct.new(:id, :title, :completed)

  def initialize
    @todos = []
    @on_changes = []
  end

  def notify
    @on_changes.each do |on_change|
      on_change.call
    end
  end

  def <<(todo)
    @todos << Item.new(SecureRandom.uuid, todo, false)
    notify
  end

  def toggle_all(checked)
    @todos.each do |todo|
      todo.completed = checked
    end
    notify
  end

  def toggle(todo)
    todo.completed = !todo.completed
    notify
  end

  def save(todo, text)
    todo.title = text
    notify
  end

  def destroy(todo)
    @todos.delete(todo)
    notify
  end

  def clear_completed
    @todos.delete_if {|todo| todo.completed }
    notify
  end

  def subscribe(&on_change)
    @on_changes << on_change
  end

  def to_s
    self.inspect
  end

  def inspect
    @todos.inspect
  end
end
