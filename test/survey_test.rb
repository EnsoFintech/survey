require 'test_helper'

class SurveyTest < ActiveSupport::TestCase

  test "should pass if user b was the more right answers" do
    user_a = create_user
    user_b = create_user
    survey = create_survey_with_questions(4)

    create_attempt_for(user_a, survey)
    create_attempt_for(user_b, survey, :all => :right)

    refute_equal user_b.id, participant_with_more_wrong_answers(survey).id
    assert_equal user_b.id, participant_with_more_right_answers(survey).id
  end

  test "should pass if all the users has the same score" do
    user_a = create_user
    user_b = create_sti_user
    survey = create_survey_with_questions(4)

    att1 = create_attempt_for(user_a, survey, :all => :right)
    att2 = create_attempt_for(user_b, survey, :all => :right)

    att1.reload
    att2.reload
    assert_equal participant_score(user_a, survey),
                 participant_score(user_b, survey)
  end

  test "should pass if user a was the winner of survey" do
    user_a = create_user
    user_b = create_user
    survey_a = create_survey_with_questions(4)
    survey_b = create_survey_with_questions(8)

    create_attempt_for(user_a, survey_a)
    create_attempt_for(user_b, survey_a, :all => :right)

    create_attempt_for(user_a, survey_b, :all => :right)
    create_attempt_for(user_b, survey_b)

    assert_equal user_a, participant_with_more_right_answers(survey_b)
    assert_equal user_b, participant_with_more_right_answers(survey_a)

    assert_equal user_a, participant_with_more_wrong_answers(survey_a)
    assert_equal user_b, participant_with_more_wrong_answers(survey_b)
  end

end