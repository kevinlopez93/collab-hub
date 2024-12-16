module TaskAasm
  extend ActiveSupport::Concern

  included do
    include AASM

    aasm column: :workflow_status do
      state :todo, initial: true
      state :pending
      state :in_progress
      state :completed

      # Definición de transiciones
      event :to_start do
        transitions from: :todo, to: :in_progress
      end

      event :complete do
        transitions from: :in_progress, to: :completed
      end

      event :revert_to_todo do
        transitions from: [ :completed, :in_progress ], to: :todo
      end
    end
  end
end
