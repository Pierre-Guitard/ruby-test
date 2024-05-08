require 'json'

# Your code

json_file = File.open "data.json"
data = JSON.load json_file

workers_json = data["workers"]
shifts_json = data["shifts"]

class Worker
  attr_accessor :id, :first_name, :price_per_shift, :payment

  def initialize(id, first_name, price_per_shift)
      @id = id
      @first_name = first_name
      @price_per_shift = price_per_shift
      @payment = 0
  end

  def to_s
    "{ id: #{id}, first_name: #{first_name}, price_per_shift: #{price_per_shift}, payment: #{payment} }"
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
  new_worker = Worker.new(id = worker["id"], first_name = worker["first_name"], price_per_shift = worker["price_per_shift"] )
  workers << new_worker
end

shifts_json.each do |shift|
  new_shift = Shift.new(id = shift["id"], planning_id = shift["planning_id"], user_id = shift["user_id"], start_date = shift["start_date"]  )
  shifts << new_shift
end

shifts.each do |shift|
  workers.each do |worker|
    worker.payment += worker.price_per_shift if worker.id == shift.user_id
  end
end

File.open('output.json', 'w') do |f|
  f.write(JSON.pretty_generate(workers))
end
