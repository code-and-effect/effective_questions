module Effective
  class ResponseOption < ActiveRecord::Base
    belongs_to :response
    belongs_to :question_option
  end
end
