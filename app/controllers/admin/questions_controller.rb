module Admin
  class QuestionsController < ApplicationController
    before_action(:authenticate_user!) if defined?(Devise)
    before_action { EffectiveResources.authorize!(self, :admin, :effective_questions) }

    include Effective::CrudController

    def permitted_params
      params.require(:effective_question).permit!
    end

  end
end
