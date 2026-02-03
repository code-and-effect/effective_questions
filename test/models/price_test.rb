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

  test 'question_answer to_s for price' do
    value = 1999 # $19.99

    question = build_question(questionable, 'Price', scored: true)

    answer = question.question_answers.build(operation: 'Equal to', price: value)
    assert_equal 'Equal to $19.99', answer.to_s

    answer.assign_attributes(operation: 'Less than', price: value)
    assert_equal 'Less than $19.99', answer.to_s

    answer.assign_attributes(operation: 'Less than or equal to', price: value)
    assert_equal 'Less than or equal to $19.99', answer.to_s

    answer.assign_attributes(operation: 'Greater than', price: value)
    assert_equal 'Greater than $19.99', answer.to_s

    answer.assign_attributes(operation: 'Greater than or equal to', price: value)
    assert_equal 'Greater than or equal to $19.99', answer.to_s

    answer.assign_attributes(operation: 'Within range', price: nil, price_begin: 1000, price_end: 5000)
    assert_equal 'Between $10.00 and $50.00', answer.to_s
  end
end
