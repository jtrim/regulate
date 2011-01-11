class User

  attr_accessor :role , :first_name , :last_name , :email

  def initialize
    @role = "editor"
    @first_name = "Sir Lucius"
    @last_name = "Leftfoot"
    @email = "sir_lucius@quickleft.com"
  end

  def is_admin?
    @role == "admin"
  end

  def is_editor?
    @role == "editor"
  end

end
