namespace :updater_repositories do
  desc "Update repositories"
  task update: :environment do
    User.where.not(github_credentials: {}).each do |user|
      UpdateRepositoriesJob.perform_later(user.id)
    end
  end
end