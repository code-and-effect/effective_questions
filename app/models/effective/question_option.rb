module Effective
  class QuestionOption < ActiveRecord::Base
    belongs_to :question

    effective_resource do
      title         :text
      position      :integer

      #correct       :boolean

      timestamps
    end

    before_validation(if: -> { question.present? }) do
      self.position ||= (question.question_options.map { |obj| obj.position }.compact.max || -1) + 1
    end

    scope :sorted, -> { order(:position) }

    validates :title, presence: true
    validates :position, presence: true

    def to_s
      title.presence || model_name.human
    end

  end
end
