class RoleUserEnum < EnumerateIt::Base
  associate_values(
    developer: 0,
    admin: 1,
    project_manager: 2
  )
end
