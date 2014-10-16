class SeedProfileQuestions < ActiveRecord::Migration
  def up
    [
      "What are your favorite hobbies?",
      "What are some thing you do to help yourself feel better?",
      "How do you relax after a long day?",
      "What are 2-3 words you would use to describe yourself?",
      "What's your favorite form of entertainment? (Share your favorite book, movie or tv show!)"
    ].each do |q|
      SocialNetworking::ProfileQuestion.create(question_text: q)
    end
  end

  def down
  end
end
