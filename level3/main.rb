require 'json'
require 'date'

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

  def to_json(option = {})
    {'id' => @id, 'first_name' => @first_name, 'status' => @status, 'payment' => @payment}.to_json
  end

  def self.from_json string
    data = JSON.load string
    self.new data['id'], data['first_name'],  data['status'],  data['payment']
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

  def to_s
    "id: #{id}, planing_id: #{planning_id}, user_id: #{user_id}, start_date: #{start_date},"
  end
end

workers = []
shifts = []
shifts_with_problems = []

workers_json.each do |worker|
  new_worker = Worker.new(id = worker["id"], first_name = worker["first_name"], status = worker["status"])
  workers << new_worker if new_worker.status == "medic" || new_worker.status == "interne"
end

shifts_json.each do |shift|
  new_shift = Shift.new(id = shift["id"], planning_id = shift["planning_id"], user_id = shift["user_id"], start_date = shift["start_date"])
  if new_shift.user_id.class == Integer
    shifts << new_shift
  else
    shifts_with_problems << shift
  end
end

def set_price(date, worker)
  date_parsed = DateTime.parse(date).to_date
  day = date_parsed.wday

  if worker.status == "medic"
    price_per_shift = 270
  else
    price_per_shift = 126
  end

  if day == 0 || day == 6
    worker.payment = worker.payment += price_per_shift*2
  else
    worker.payment += price_per_shift
  end
end

shifts.each do |shift|
  workers.each do |worker|
    if worker.id == shift.user_id
      set_price(shift.start_date, worker)
    end
  end
end

data = []
workers.to_json
data << workers
data << shifts_with_problems

File.open('output.json', 'w') do |f|
  f.write(JSON.pretty_generate(data))
end
