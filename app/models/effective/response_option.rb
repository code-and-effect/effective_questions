module Effective
  class ResponseOption < ActiveRecord::Base
    belongs_to :response
    belongs_to :question_option

    def to_s
      question_option&.to_s
    end

  end
end
