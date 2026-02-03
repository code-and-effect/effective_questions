class Admin::EffectiveQuestionsDatatable < Effective::Datatable
  datatable do
    reorder :position

    col :updated_at, visible: false
    col :created_at, visible: false
    col :id, visible: false

    if attributes[:follow_up]
      col :show_if_value_to_s, label: 'When answered with'
    else
      col :questionable
    end

    col :position, visible: attributes[:follow_up].blank? do |question|
      question.position.to_i + 1
    end

    col :title
    col :body, as: :text, visible: !attributes[:follow_up]
    col :required

    col :category, label: 'Type'
    col :question_options, label: 'Options'

    unless attributes[:follow_up]
      col :follow_up_questions, action: false, label: 'Follow up questions'
    end

    col :scored
    col :answer_to_s, label: 'Answer'

    col :task
    col :points

    actions_col
  end

  collection do
    scope = Effective::Question.all.deep

    if attributes[:follow_up]
      scope = scope.where(follow_up: true, question_id: attributes[:question_id])
    else
      scope = scope.where(question_id: nil)
    end

    scope
  end

end
