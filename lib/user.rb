require_relative 'questions_database'

class User
include Save

  def self.find_by_id(id)
    query = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        users
      WHERE
        users.id = ?
    SQL

    User.new(query.first)
  end

  def self.find_by_name(first_name, last_name)
    params = [first_name, last_name]
    query = QuestionsDatabase.instance.execute(<<-SQL, *params)
      SELECT
        *
      FROM
        users
      WHERE
        users.first_name = ?
        AND users.last_name = ?
    SQL

    User.new(query.first)
  end

  attr_accessor :id, :first_name, :last_name

  def initialize(options = {})
    @id = options['id']
    @first_name = options['first_name']
    @last_name = options['last_name']
  end

  def table
    'users'
  end

  def authored_questions
    Question.find_by_user_id(@id)
  end

  def authored_replies
    Reply.find_by_user_id(@id)
  end

  def followed_questions
    QuestionFollower.followed_questions_for_user_id(@id)
  end

  def liked_questions
    QuestionLike.liked_questions_for_user_id(@id)
  end

  def average_karma
    query = QuestionsDatabase.instance.execute(<<-SQL, @id)
    SELECT
      (COUNT(question_likes.user_id) /
      CAST(COUNT(DISTINCT question_likes.question_id) AS FLOAT)) AS avg
    FROM
      question_likes
    WHERE
      question_likes.question_id = (
        SELECT
          id
        FROM
          questions
        WHERE
          questions.user_id = ?
      )
    SQL

    query.first['avg'].nil? ? 0 : query.first['avg']
  end

end





