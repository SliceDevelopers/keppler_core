module KepplerLanguages
  # Policy for Language model
  class LanguagePolicy < ControllerPolicy
    attr_reader :user, :objects

    def initialize(user, objects)
      @user = user
      @objects = objects
    end
  end
end