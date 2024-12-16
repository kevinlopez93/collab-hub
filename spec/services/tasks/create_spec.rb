require "rails_helper"

RSpec.describe Tasks::Create, type: :service do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:task_params) { { title: "New Task", description: "Task description", due_date: "2024-12-30", board_id: create(:board).id } }
  let(:users_assigned) { [other_user.id] } # Asignando un usuario a la tarea

  describe "#call" do
    context "when creating task and assigning users" do
      it "creates the task and assigns users to it" do
        service = Tasks::Create.new(task_params, user, users_assigned)

        task = service.call

        # Verificar que la tarea se haya creado
        expect(task).to be_persisted
        expect(task.title).to eq("New Task")
        expect(task.description).to eq("Task description")
        expect(task.due_date).to eq("2024-12-30")

        # Verificar que el usuario asignado está relacionado con la tarea
        expect(task.user_tasks.count).to eq(1)
        expect(task.user_tasks.first.user_id).to eq(other_user.id)
      end
    end

    context "when no users are assigned" do
      it "creates the task without assigning users" do
        service = Tasks::Create.new(task_params, user, [])

        task = service.call

        # Verificar que la tarea se haya creado
        expect(task).to be_persisted
        expect(task.title).to eq("New Task")
        expect(task.description).to eq("Task description")

        # Verificar que no se asignaron usuarios
        expect(task.user_tasks.count).to eq(0)
      end
    end

    context "when task creation fails" do
      it "does not assign users if task creation fails" do
        invalid_params = { title: "", description: "Invalid task", due_date: "2024-12-30" } # Título vacío

        service = Tasks::Create.new(invalid_params, user, users_assigned)

        task = service.call

        # Verificar que la tarea no se creó
        expect(task.persisted?).to eq(false)

        # Verificar que no se asignaron usuarios
        expect(task.user_tasks.count).to eq(0)
      end
    end
  end
end