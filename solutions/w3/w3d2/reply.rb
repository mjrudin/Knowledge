require 'question'
require 'questions_database'
require 'user'

class Reply
  def self.find(id)
    replies_data = QuestionsDatabase.execute(<<-SQL, id)
      SELECT *
        FROM replies
       WHERE replies.id = ?
    SQL
    
    Reply.new(replies_data[0])
  end

  def self.find_by_question_id(question_id)
    replies_data = QuestionsDatabase.execute(<<-SQL, question_id)
      SELECT *
        FROM replies
       WHERE replies.question_id = ?
    SQL
    
    replies_data.map { |reply_data| Reply.new(reply_data) }
  end
  
  def self.find_by_parent_id(parent_reply_id)
    replies_data = QuestionsDatabase.execute(<<-SQL, parent_reply_id)
      SELECT *
        FROM replies
       WHERE replies.parent_reply_id = ?
    SQL
    
    replies_data.map { |reply_data| Reply.new(reply_data) }
  end
  
  def self.find_by_user_id(user_id)
    replies_data = QuestionsDatabaes.execute(<<-SQL, user_id)
      SELECT *
        FROM replies
       WHERE replies.author_id = ?
    SQL
    
    replies_data.map { |reply_data| Reply.new(reply_data) }
  end
  
  attr_reader :id
  attr_accessor :question_id, :parent_reply_id, :author_id, :body
  
  def initialize(options)
    @id, @question_id, @parent_reply_id, @author_id, @body =
      options.values_at(
        "id", "question_id", "parent_reply_id", "author_id", "body"
      )
  end
  
  def attrs
    { :question_id => question_id,
      :parent_reply_id => parent_reply_id,
      :author_id => author_id,
      :body => body }
  end
  
  def save
    if @id
      QuestionsDatabase.execute(<<-SQL, attrs.merge({ :id => :id }))
        UPDATE replies
           SET question_id = :question_id,
               parent_reply_id = :parent_reply_id,
               author_id = :author_id,
               body = :body
         WHERE users.id = :id
      SQL
    else
      QuestionsDatabase.execute(<<-SQL, attrs)
        INSERT INTO replies (question_id, parent_reply_id, author_id, body)
        VALUES (:question_id, :parent_reply_id, :author_id, :body)
      SQL
      
      @id = QuestionsDatabase.instance.last_insert_row_id
    end
  end
  
  def question
    Question.find(question_id)
  end
  
  def parent_reply
    Reply.find(parent_reply_id)
  end
  
  def child_replies
    Reply.find_by_parent_id(id)
  end
  
  def author
    User.find(author_id)
  end
end
