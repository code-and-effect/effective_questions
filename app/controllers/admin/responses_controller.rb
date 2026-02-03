module Admin
  class ResponsesController < ApplicationController
    before_action(:authenticate_user!) if defined?(Devise)
    before_action { EffectiveResources.authorize!(self, :admin, :effective_questions) }

    include Effective::CrudController

    def permitted_params
      params.require(:effective_response).permit!
    end

  end
end
