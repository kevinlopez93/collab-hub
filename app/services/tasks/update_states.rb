module Tasks
  class UpdateStates
    attr_reader :task, :event, :errors

    def initialize(task, event)
      @task = task
      @event = event
      @errors = nil
    end

    def call
      return error_response("No event provided") unless event
      return error_response("Invalid event") unless valid_events

      process_event
    end

    private

    def process_event
      if task.send("may_#{event}?")
        task.send("#{event}!")
        { result: true, errors: nil }
      else
        error_response("Invalid state transition")
      end
    rescue StandardError => e
      error_response(e.message)
    end

    def error_response(message)
      @errors = message
      { result: false, errors: @errors }
    end

    def valid_events
      valid_events = Task.aasm.events.map(&:name)
      valid_events.include?(event.to_sym)
    end
  end
end