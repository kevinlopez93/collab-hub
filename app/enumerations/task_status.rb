class TaskStatus < EnumerateIt::Base
  associate_values(
    :todo,
    :pending,
    :in_progress,
    :completed
  )
end