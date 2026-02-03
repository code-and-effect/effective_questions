require 'test_helper'

class LongAnswerTest < ActiveSupport::TestCase
  let(:questionable) { create_user! }
  let(:responsable) { create_user! }

  test 'Equal to long answer' do
    value = 'This is the correct long answer.'

    question = build_question(questionable, 'Long Answer', scored: true)
    answer = question.question_answers.build(operation: 'Equal to', long_answer: value)

    response = responsable.response(question: question)
    response.assign_attributes(long_answer: value)
    assert response.correct?

    response.assign_attributes(long_answer: 'This is a different answer.')
    refute response.correct?
  end

  test 'Contains long answer' do
    value = 'keyword'

    question = build_question(questionable, 'Long Answer', scored: true)
    answer = question.question_answers.build(operation: 'Contains', long_answer: value)

    response = responsable.response(question: question)
    response.assign_attributes(long_answer: 'This answer contains the keyword we are looking for.')
    assert response.correct?

    response.assign_attributes(long_answer: 'This answer does not have it.')
    refute response.correct?
  end

  test 'Does not contain long answer' do
    value = 'forbidden'

    question = build_question(questionable, 'Long Answer', scored: true)
    answer = question.question_answers.build(operation: 'Does not contain', long_answer: value)

    response = responsable.response(question: question)
    response.assign_attributes(long_answer: 'This is an acceptable answer.')
    assert response.correct?

    response.assign_attributes(long_answer: 'This answer has the forbidden word.')
    refute response.correct?
  end
end
