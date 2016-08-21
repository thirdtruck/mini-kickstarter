require 'sqlite3'

class MiniKickstarterDB
  def initialize(filename)
    uninitialized = ! File.exist?(filename)

    @db = SQLite3::Database.new(filename)

    if uninitialized
      initialize_db
    end
  end

  def back_project(given_name, project_id, credit_card_number, backing_amount)
    backing_count = @db.get_first_value('select count(id) from backings where credit_card_number = ?',
                                        credit_card_number)

    if backing_count > 0
      raise ProjectAlreadyBackedError
    end

    @db.execute('insert into backings values (?, ?, ?, ?, ?)',
                nil,
                given_name,
                project_id,
                credit_card_number,
                backing_amount)
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

