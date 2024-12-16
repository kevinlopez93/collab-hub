module Users
  class Update
    def initialize(user, params)
      @user = user
      @params = params
    end

    def call
      update_user
      @user
    end

    private

    def update_user
      @user.update(@params)
    end
  end
end