require_relative 'questions_database'

class Reply
include Save

  def self.find_by_id(id)
    query = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        replies
      WHERE
        replies.id = ?
    SQL

    Reply.new(query.first)
  end

  def self.find_by_question_id(question_id)
    query = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        *
      FROM
        replies
      WHERE
        replies.question_id = ?;
    SQL

    query.each_with_object([]) do |data, replies|
      replies << Reply.new(data)
    end
  end

  def self.find_by_user_id(user_id)
    query = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        *
      FROM
        replies
      WHERE
        replies.user_id = ?;
    SQL

    query.each_with_object([]) do |data, replies|
      replies << Reply.new(data)
    end
  end

  attr_accessor :id, :body, :user_id, :question_id, :reply_id

  def initialize(options = {})
    @id = options['id']
    @body = options['body']
    @user_id = options['user_id']
    @question_id = options['question_id']
    @reply_id = options['reply_id']
  end

  def table
    'replies'
  end

  def author
    query = QuestionsDatabase.instance.execute(<<-SQL, @user_id)
      SELECT
        first_name, last_name
      FROM
        users
      WHERE
        users.id = ?
    SQL

    User.new(query.first)
  end

  def question
    query = QuestionsDatabase.instance.execute(<<-SQL, @question_id)
      SELECT
        *
      FROM
        questions
      WHERE
        questions.id = ?
    SQL

    Question.new(query.first)
  end

  def parent_reply
    query = QuestionsDatabase.instance.execute(<<-SQL, @replies_id)
      SELECT
        *
      FROM
        replies
      WHERE
        replies.id = ?
    SQL

    query.first.nil? ? nil : Reply.new(query.first)
  end

  def child_replies
    query = QuestionsDatabase.instance.execute(<<-SQL, @id)
      SELECT
        *
      FROM
        replies
      WHERE
        reply_id = ?
    SQL

    query.each_with_object([]) do |data, child_replies|
      child_replies << Reply.new(data)
    end
  end

end




