require 'json'

# Your code

json_file = File.open "data.json"
data = JSON.load json_file

workers_json = data["workers"]
shifts_json = data["shifts"]

class Worker
  attr_accessor :id, :first_name, :status, :payment

  def initialize(id, first_name, status)
      @id = id
      @first_name = first_name
      @status = status
      @payment = 0
  end

  def to_s
    "{ id: #{id}, first_name: #{first_name}, status: #{status}, payment: #{payment} }"
  end
end

class Shift
  attr_accessor :id, :planning_id, :user_id, :start_date

  def initialize(id, planning_id, user_id, start_date)
      @id = id
      @planning_id = planning_id
      @user_id = user_id
      @start_date = start_date
  end
end

workers = []
shifts = []

workers_json.each do |worker|
  new_worker = Worker.new(id = worker["id"], first_name = worker["first_name"], status = worker["status"] )
  if new_worker.status == "medic" || new_worker.status == "interne"
    workers << new_worker
  end
end

shifts_json.each do |shift|
  new_shift = Shift.new(id = shift["id"], planning_id = shift["planning_id"], user_id = shift["user_id"], start_date = shift["start_date"]  )
  shifts << new_shift
end

shifts.each do |shift|
  workers.each do |worker|
    if worker.id == shift.user_id
      if worker.status == "medic"
        worker.payment += 270
      else
        worker.payment += 126
      end
    end
  end
end

File.open('output.json', 'w') do |f|
  f.write(JSON.pretty_generate(workers))
end
