require_relative 'question'
require_relative 'questions_database'
require_relative 'user'

class QuestionFollower
  def self.followers_for_question_id(question_id)
    users_data = QuestionsDatabase.execute(<<-SQL, question_id)
      SELECT users.*
        FROM users
        JOIN question_followers
          ON question_followers.user_id = users.id
       WHERE question_followers.question_id = ?
    SQL
    
    users_data.map { |user_data| User.new(user_data) }
  end
  
  def self.followed_questions_for_user_id(user_id)
    questions_data = QuestionsDatabase.execute(<<-SQL, user_id)
      SELECT questions.*
        FROM questions
        JOIN question_followers
          ON question_followers.question_id = questions.id
       WHERE question_followers.user_id = ?
    SQL
    
    questions_data.map { |question_data| Question.new(question_data) }
  end
  
  def self.most_followed_questions(n)
    questions_data = QuestionsDatabase.execute(<<-SQL, n)
      SELECT *
        FROM questions
        JOIN question_followers
          ON question_followers.question_id = questions.id
       ORDER BY COUNT(*)
       LIMIT ?
    SQL
    
    questions_data.map { |question_data| Question.new(question_data) }
  end
end
