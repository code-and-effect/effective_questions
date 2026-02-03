require 'test_helper'

class ShortAnswerTest < ActiveSupport::TestCase
  let(:questionable) { create_user! }
  let(:responsable) { create_user! }

  test 'Equal to short answer' do
    value = 'correct'

    question = build_question(questionable, 'Short Answer', scored: true)
    answer = question.question_answers.build(operation: 'Equal to', short_answer: value)

    response = responsable.response(question: question)
    response.assign_attributes(short_answer: value)
    assert response.correct?

    response.assign_attributes(short_answer: 'incorrect')
    refute response.correct?
  end

  test 'Contains short answer' do
    value = 'key'

    question = build_question(questionable, 'Short Answer', scored: true)
    answer = question.question_answers.build(operation: 'Contains', short_answer: value)

    response = responsable.response(question: question)
    response.assign_attributes(short_answer: 'keyword')
    assert response.correct?

    response.assign_attributes(short_answer: 'nope')
    refute response.correct?
  end

  test 'Does not contain short answer' do
    value = 'bad'

    question = build_question(questionable, 'Short Answer', scored: true)
    answer = question.question_answers.build(operation: 'Does not contain', short_answer: value)

    response = responsable.response(question: question)
    response.assign_attributes(short_answer: 'good')
    assert response.correct?

    response.assign_attributes(short_answer: 'bad')
    refute response.correct?
  end
end
