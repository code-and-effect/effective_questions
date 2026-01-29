class Admin::EffectiveQuestionableResultsDatatable < Effective::Datatable
  datatable do
    col :responsable

    col :position, visible: false
    col :category, search: Effective::Question::CATEGORIES, visible: false

    col :question, search: questionable.questions.pluck(:title).sort
    col :responses
  end

  collection do
    questionable.completed_responses.flat_map do |response|
      rows = if response.question.question_option?
        response.question_options.map do |question_option|
          [
            response.responsable.try(:token) || response.responsable_id,
            response.question.position,
            response.question.category,
            response.question.to_s,
            question_option.to_s
          ]
        end
      elsif response.response.present?
        [
          [
            response.responsable.try(:token) || response.responsable_id,
            response.question.position,
            response.question.category,
            response.question.to_s,
            response.response.to_s
          ]
        ]
      else
        []
      end
    end
  end

  def questionable
    @questionable ||= (attributes[:questionable_type].constantize).where(id: attributes[:questionable_id]).first!
  end

end
