require 'sqlite3'

module Helper

	def add_table(username)
		db = SQLite3::Database.new("helper_database")
		create_table = <<-SQL 
			CREATE TABLE IF NOT EXISTS "#{username}" (
				id INTEGER PRIMARY KEY,
				user_id INT,
				title VARCHAR(225),
				description VARCHAR(800),
				satisfaction INT,
				people INT,
				travel INT,
				strength INT,
				procrastinate INT,
				socialize INT,
				week_repeat VARCHAR(225),
				month_repeat VARCHAR(225),
				year_repeat VARCHAR(225),
				start_date DATE,
				end_date DATE,
				remaining_day INT,
				priority_count INT,
				created_on TIMESTAMP,
				FOREIGN KEY (user_id) REFERENCES user(id)
			);	
		SQL
		db.execute(create_table)
		db_results_as_hash = true
	end 

end
