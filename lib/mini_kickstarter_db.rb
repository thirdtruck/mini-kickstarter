require 'sqlite3'

class MiniKickstarterDB
  def initialize(filename)
    uninitialized = ! File.exist?(filename)

    @db = SQLite3::Database.new(filename)

    if uninitialized
      initialize_db
    end
  end

  def create_project(project_name, target_dollar_amount)
    @db.execute('insert into projects values(?, ?, ?);', nil, project_name, target_dollar_amount)
  end

  def find_project_id_by_project_name(project_name)
    @db.get_first_value('select id from projects where project_name = ?', project_name)
  end

  def back_project(project_name, given_name, credit_card_number, backing_amount)
    project_id = find_project_id_by_project_name(project_name)
    backing_count = @db.get_first_value('select count(id) from backings where credit_card_number = ? and project_id = ?',
                                        credit_card_number,
                                        project_id)

    if backing_count > 0
      raise ProjectAlreadyBackedError
    end

    @db.execute('insert into backings values (?, ?, ?, ?, ?);',
                nil,
                given_name,
                project_id,
                credit_card_number,
                backing_amount)
  end

  def find_project_by_project_name(project_name)
    @db.get_first_row('select * from projects where project_name = ?', project_name)
  end

  def find_backings_by_project_id(project_id)
    @db.execute('select * from backings where project_id = ?', project_id)
  end

  def find_project_names_backing_dollar_amounts_by_given_name(given_name)
    rows = @db.execute('select projects.project_name, backings.backing_dollar_amount from backings join projects on projects.id = backings.project_id where backings.given_name = ?', given_name)
    rows.map { |row| { project_name: row[0], backing_dollar_amount: row[1] } }
  end

  private

  def initialize_db
    # Storing dollar amounts as integers to avoid floating point errors.
    @db.execute(%q{
      create table projects (
        id INTEGER PRIMARY KEY ASC AUTOINCREMENT,
        project_name TEXT,
        target_dollar_amount INTEGER
      );
    })

    @db.execute(%q{
      create table backings (
        id INTEGER PRIMARY KEY ASC AUTOINCREMENT,
        given_name TEXT,
        project_id INTEGER,
        credit_card_number TEXT,
        backing_dollar_amount INTEGER
      );
    })
  end

  class ProjectAlreadyBackedError < StandardError
  end
end

