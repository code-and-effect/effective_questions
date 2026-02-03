require 'test_helper'

class PriceTest < ActiveSupport::TestCase
  let(:questionable) { create_user! }
  let(:responsable) { create_user! }

  test 'Equal to price' do
    value = 1000 # $10.00 stored as cents

    question = build_question(questionable, 'Price', scored: true)
    answer = question.question_answers.build(operation: 'Equal to', price: value)

    response = responsable.response(question: question)
    response.assign_attributes(price: value)
    assert response.correct?

    response.assign_attributes(price: value + 100)
    refute response.correct?
  end

  test 'Within range price' do
    value = 1000

    question = build_question(questionable, 'Price', scored: true)
    answer = question.question_answers.build(operation: 'Within range', price_begin: value - 500, price_end: value + 500)

    response = responsable.response(question: question)
    response.assign_attributes(price: value)
    assert response.correct?

    response.assign_attributes(price: value + 1000)
    refute response.correct?
  end

  test 'Less than price' do
    value = 1000

    question = build_question(questionable, 'Price', scored: true)
    answer = question.question_answers.build(operation: 'Less than', price: value + 100)

    response = responsable.response(question: question)
    response.assign_attributes(price: value)
    assert response.correct?

    response.assign_attributes(price: value + 100)
    refute response.correct?
  end

  test 'Less than or equal to price' do
    value = 1000

    question = build_question(questionable, 'Price', scored: true)
    answer = question.question_answers.build(operation: 'Less than or equal to', price: value)

    response = responsable.response(question: question)
    response.assign_attributes(price: value)
    assert response.correct?

    response.assign_attributes(price: value + 100)
    refute response.correct?
  end

  test 'Greater than price' do
    value = 1000

    question = build_question(questionable, 'Price', scored: true)
    answer = question.question_answers.build(operation: 'Greater than', price: value - 100)

    response = responsable.response(question: question)
    response.assign_attributes(price: value)
    assert response.correct?

    response.assign_attributes(price: value - 100)
    refute response.correct?
  end

  test 'Greater than or equal to price' do
    value = 1000

    question = build_question(questionable, 'Price', scored: true)
    answer = question.question_answers.build(operation: 'Greater than or equal to', price: value)

    response = responsable.response(question: question)
    response.assign_attributes(price: value)
    assert response.correct?

    response.assign_attributes(price: value - 100)
    refute response.correct?
  end
end
