require 'test_helper'

class ResponseTest < ActiveSupport::TestCase
  let(:questionable) { create_user! }
  let(:responsable) { create_user! }

  test 'Equals to date' do
    value = Date.today

    question = build_question(questionable, 'Date', scored: true)
    answer = question.question_answers.build(operation: 'Equal to', date: value)

    response = responsable.response(question: question)
    response.assign_attributes(date: value)

    assert response.correct?
  end

  test 'Within range date' do
    value = Date.today

    question = build_question(questionable, 'Date', scored: true)
    answer = question.question_answers.build(operation: 'Within range', date_begin: value - 1.day, date_end: value + 1.day)

    response = responsable.response(question: question)
    response.assign_attributes(date: value)

    assert response.correct?
  end

end
