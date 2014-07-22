require_relative 'questions_database'
require_relative 'user'
require_relative 'reply'
require_relative 'question_follower'

class Question

  def self.find_by_id(id)
    query = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        questions
      WHERE
        questions.id = ?;
    SQL

    Question.new(query.first)
  end

  def self.find_by_user_id(user_id)
    query = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        *
      FROM
        questions
      WHERE
        questions.user_id = ?;
    SQL

    query.each_with_object([]) do |data, questions|
      questions << Question.new(data)
    end
  end

  def self.most_followed(n)
    QuestionFollower.most_followed_questions(n)
  end

  attr_accessor :id, :title, :body, :user_id

  def initialize(options = {})
    @id = options['id']
    @title = options['title']
    @body = options['body']
    @user_id = options['user_id']
  end

  def author
    query = QuestionsDatabase.instance.execute(<<-SQL, @user_id)
      SELECT
        first_name, last_name
      FROM
        users
      WHERE
        users.id = ?;
    SQL

    User.new(query.first)
  end

  def replies
    Reply.find_by_question_id(@id)
  end

  def followers
    QuestionFollower.followers_for_question_id(@id)
  end

end





