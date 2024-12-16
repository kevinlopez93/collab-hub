class UpdateRepositoriesJob < ApplicationJob
  queue_as :repositories

  def perform(user_id)
    @current_user = User.find(user_id)
    build_repositories
  end

  private

  def build_repositories
    results = Github::FetchRepositories.new(@current_user.github_credentials["access_token"]).call

    if results[:success] && results[:result].any?
      existing_ids = repositories.pluck(:remote_id).map(&:to_i)
      response_ids = results[:result].pluck("id")

      ids_to_create = response_ids - existing_ids
      ids_to_update = existing_ids - response_ids

      create_new_repositories(ids_to_create, results)
      update_existing_repositories(ids_to_update, results)
    end
  end

  def create_new_repositories(ids_to_create, results)
    ids_to_create.each do |new_id_repository|
      new_repository = results[:result].find { |repository| repository["id"] == new_id_repository }

      Repository.create(
        remote_id: new_repository["id"],
        node_id: new_repository["node_id"],
        name: new_repository["name"],
        full_name: new_repository["full_name"],
        private: new_repository["private"],
        owner_login: new_repository["owner"]["login"],
        description: new_repository["description"],
        url_api: new_repository["url"],
        url_html: new_repository["html_url"],
        remote_created_at: new_repository["created_at"],
        remote_updated_at: new_repository["updated_at"],
        visibility: new_repository["visibility"],
        language: new_repository["language"],
        user: @current_user
      )
    end
  end


  def update_existing_repositories(ids_to_update, results)
    ids_to_update.each do |repository_id|
      repository = results[:result].find { |repository| repository["id"] == repository_id }
      existing_repository = repositories.find_by(remote_id: repository_id)

      existing_repository.update(
        node_id: repository["node_id"],
        name: repository["name"],
        full_name: repository["full_name"],
        private: repository["private"],
        owner_login: repository["owner"]["login"],
        description: repository["description"],
        url_api: repository["url"],
        url_html: repository["html_url"],
        remote_created_at: repository["created_at"],
        remote_updated_at: repository["updated_at"],
        visibility: repository["visibility"],
        language: repository["language"]
      ) if existing_repository
    end
  end

  def repositories
    @repositories ||= @current_user.repositories
  end
end
