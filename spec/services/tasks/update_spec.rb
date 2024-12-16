require "rails_helper"

RSpec.describe Tasks::Update, type: :service do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:task) { create(:task, creator: user) }
  let(:existing_user) { create(:user) }

  let(:task_params) do
    { title: "Updated Task", description: "Updated description", due_date: "2025-01-01", board_id: create(:board).id }
  end
  let(:users_assigned) { [other_user.id] } # Asignando un nuevo usuario a la tarea
  
  describe "#call" do
    context "when updating task and user assignments" do
      before do
        # Asignamos usuarios a la tarea para probar la actualización
        task.user_tasks.create!(user_id: existing_user.id)
      end

      it "updates the task and user assignments" do
        service = Tasks::Update.new(task, task_params, users_assigned)
        
        updated_task = service.call

        # Verificar que la tarea se haya actualizado
        expect(updated_task.title).to eq("Updated Task")
        expect(updated_task.description).to eq("Updated description")
        expect(updated_task.due_date).to eq("2025-01-01")

        # Verificar que solo los usuarios asignados estén relacionados con la tarea
        expect(updated_task.user_tasks.count).to eq(1)
        expect(updated_task.user_tasks.first.user_id).to eq(other_user.id)
      end
    end

    context "when users are removed from task" do
      before do
        # Asignamos usuarios a la tarea para probar la eliminación de asignaciones
        task.user_tasks.create!(user_id: existing_user.id)
        task.user_tasks.create!(user_id: other_user.id)
      end

      it "removes unassigned users from the task" do
        service = Tasks::Update.new(task, task_params, [])  # No asignamos nuevos usuarios

        updated_task = service.call

        # Verificar que solo el creador de la tarea esté asignado
        expect(updated_task.user_tasks.count).to eq(0)
      end
    end

    context "when task update fails" do
      it "does not update the task if the update fails" do
        invalid_params = { title: nil, description: "Invalid task", due_date: "2025-01-01" } # Título vacío

        service = Tasks::Update.new(task, invalid_params, users_assigned)

        result = service.call

        # Verificar que la tarea no se haya actualizado
        expect(result).to eq(false)
        expect(task.title).not_to eq("")
      end
    end
  end
end