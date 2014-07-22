module Save
  def save
    params = self.instance_variables
    params.shift

    unless self.id.nil?

      params_str = convert_params_for_update(params)
      params << :@id

      QuestionsDatabase.instance.execute(<<-SQL, *params)
        UPDATE
          "#{self.table}"
        SET
          "#{params_str}"
        WHERE
          id = ?
        SQL

    else

      QuestionsDatabase.instance.execute(<<-SQL, *params)
        INSERT INTO
          "#{self.table} #{convert_params_for_save(params)}"
        VALUES
          "#{question_marks(params)}"
        SQL
      @id = QuestionsDatabase.instance.last_insert_row_id
    end
  end

  def convert_params_for_update(params)
    params_str = ""
    params.each do |param|
      params_str += "#{param.to_s[1..-1]} = ?, "
    end

    params_str[0...-2]
  end

  def convert_params_for_save(params)
    params_str = "("
    params.each do |param|
      params_str += "#{param.to_s[1..-1]}, "
    end

    params_str[0...-2] + ")"
  end

  def question_marks(params)
    question_marks = "(" + ("?, "*params.length)

    question_marks[0...-2] + ")"
  end
end