require 'sqlite3'
require_relative 'db_setup'

class Task 
  
  attr_reader :start_date, :end_date, :description, :title, :urgency, :month_repeat
  
  def initialize (params = {})
    @title = params.fetch(:title, "test")
    @description = params.fetch(:description, "test")
    @satisfaction = params.fetch(:satisfaction, 5).to_i
    @procrastinate = params.fetch(:procrastinate, 5).to_i
    @people = params.fetch(:people, 2).to_i
    @travel = params.fetch(:travel, 2).to_i
    @strength = params.fetch(:strength, 2).to_i
    @socialize = params.fetch(:socialize, 3).to_i
    @week_repeat = params.fetch(:week_repeat, "no")
    @month_repeat = params.fetch(:month_repeat, "yes")
    @year_repeat = params.fetch(:year_repeat, "no")
    @start_date = Date.today
    @end_date = Date.parse(params.fetch(:end_date, " "))
    @start_date_db = Date.today.strftime('%Y-%m-%d')
    @end_date_db = params.fetch(:end_date, " ")
    @prioritization
    
    # db = SQLite3::Database.open("task_database")
    # db.execute("INSERT INTO tasks (title, description, satisfaction, procrastinate, people, travel, strength, socialize, week_repeat, month_repeat, year_repeat, start_date, end_date) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",[@title, @description, @satisfaction, @procrastinate, @people, @travel, @strength, @socialize,  @week_repeat, @month_repeat, @year_repeat, start_date_db, end_date_db])
    # # @remaining_days = (@end_date - @start_date).to_i
  end 
  
  def weight_calculation
    @satisfaction_weight = @satisfaction * 4
    @people_weight = @people *  5
    @travel_weight = @travel * 3 
    @strength_weight = @strength * 3 
    @procrastinate_weight = @procrastinate * 2 
    @socialize_weight = @socialize * 1
    @fundamental_total = [@satisfaction_weight,@people_weight,@travel_weight,@strength_weight,@procrastinate_weight,@socialize_weight].inject{|sum, n| sum + n}
    @fundamental_total
  end
  
  def importance_calculation
    @urgency = 50 if @week_repeat == "yes"
    @urgency = 75 if @month_repeat == "yes"
    @urgency = 100 if @year_repeat == "yes"
    @urgency
  end 
  
  def urgency_calculation
    @start_date = Date.today
    @bonus_points = 15 if @urgency == 75 && (@end_date - @start_date <21 )
    @bonus_points = 30 if @urgency == 75 && (@end_date - @start_date <14 )
    @bonus_points = 45 if @urgency == 75 && (@end_date - @start_date <7 )
    @bonus_points = 25 if @urgency == 100 && (@end_date - @start_date <90 )
    @bonus_points = 50 if @urgency == 100 && (@end_date - @start_date <60 )
    @bonus_points = 75 if @urgency == 100 && (@end_date - @start_date <30 )
    @bonus_points = 0 if @bonus_points == nil
    @bonus_points
  end   

  def priority_calculation
    @prioritization = weight_calculation + importance_calculation + urgency_calculation
  end 

  def insert_task(user)
    db = SQLite3::Database.open("helper_database")
    db.execute("INSERT INTO #{user} (title, description, satisfaction, procrastinate, people, travel, strength, socialize, week_repeat, month_repeat, year_repeat, start_date, end_date, priority_count) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",[@title, @description, @satisfaction, @procrastinate, @people, @travel, @strength, @socialize,  @week_repeat, @month_repeat, @year_repeat, @start_date_db, @end_date_db, @prioritization])
    @prioritization
  end 

  def self.all(user)
    db = SQLite3::Database.open("helper_database")
    db.results_as_hash = true
    db.execute("SELECT * FROM #{user}")
  end 

  def self.find(id, user)
    db = SQLite3::Database.open("helper_database")
    db.results_as_hash = true
    db.execute("SELECT * FROM #{user} WHERE id = #{id}")
  end 

  def self.list_priorities(user)
    @task_box = []
    
    Task.all(user).each do |x|
      @task_box << x
    end 
    @task_box

    @priority_box = @task_box.sort_by {|task| task["priority_count"]}.reverse
  end 

  def self.list_dates
    @date_box=@task_box.sort_by {|task| task["end_date"]}
    @date_box
  end 

  def self.list_months
    @month_box = []
    today = Date.today

    @date_box.each do |x|
      if Date.parse(x["end_date"]).month == today.month
        @month_box << x
      end  
    end 
    @month_box 
  end 

  def self.list_year
    @year_box = []
    today = Date.today

    @date_box.each do |x|
      if Date.parse(x["end_date"]).year == today.year
        @year_box << x
      end  
    end 
    @year_box 
  end  

  def self.list_week
    week_day = Date.today.strftime('%A')
    today = Date.today
    today.to_s
    @week_box = []

    end_week = (today+6).to_s if week_day == "Monday"
    end_week = (today+5).to_s if week_day == "Tuesday"
    end_week = (today+4).to_s if week_day == "Wednesday"
    end_week = (today+3).to_s if week_day == "Thursday"
    end_week = (today+2).to_s if week_day == "Friday"
    end_week = (today+1).to_s if week_day == "Saturday"
    end_week = (today+0).to_s if week_day == "Sunday"

    end_week = Date.parse(end_week)

    @date_box.each do |x|
      if Date.parse(x["end_date"]) <= end_week 
        @week_box << x
      end 
    end 
    @week_box
  end 

  def self.delete(user,id)
      db=SQLite3::Database.open("helper_database")
      db.results_as_hash = true
      db.execute("DELETE FROM #{user} where id = #{id}")
  end 

  def self.update(user,id,title,description,satisfaction,people,travel,strength,procrastinate,socialize, week_repeat,month_repeat,year_repeat,end_date)
    update_task = Task.new(title:title, satisfaction:satisfaction, procrastinate:procrastinate, people:people, travel:travel, strength:strength, socialize:socialize, week_repeat:week_repeat, month_repeat:month_repeat, year_repeat:year_repeat, end_date:end_date,description:description)
    @prioritization_2 = update_task.priority_calculation
    db = SQLite3::Database.open("helper_database")
    db.results_as_hash = true 
    db.execute("UPDATE #{user} SET title='#{title}', description='#{description}', satisfaction='#{satisfaction}', people='#{people}', travel='#{travel}', strength='#{strength}', procrastinate='#{procrastinate}', socialize='#{socialize}', week_repeat='#{week_repeat}',  start_date='#{@start_date_db}', end_date='#{end_date}', priority_count='#{@prioritization_2}' WHERE id = #{id}")
  end 

  def self.expired_tasks(user)
    #If today's date is greater than end_date, run SQL command to delete task from database
    db = SQLite3::Database.open("helper_database")
    db.results_as_hash = true
    tasks = db.execute("SELECT * FROM #{user}")
    tasks.each do |x|
      if Date.parse(x["end_date"]) < Date.today
        db.execute("DELETE FROM tasks where id=#{x["id"]}")
      end 
    end 
  end

  # def self.text_reminder 
  #   db = SQLite3::Database.open("helper_database")
  #   db.results_as_hash = true
  #   tasks = db.execute("SELECT * FROM tasks")
  #   if Date.parse(x["end_date"]) < Date.today
  #   end
  # end 

end 


    
