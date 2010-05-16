require 'java'

# setup executor
java_import 'java.util.concurrent.ThreadPoolExecutor'
java_import 'java.util.concurrent.TimeUnit'
java_import 'java.util.concurrent.LinkedBlockingQueue'
java_import 'java.util.concurrent.FutureTask'
java_import 'java.util.concurrent.Callable'

core_pool_size = 5
maximum_pool_size = 5
keep_alive_time = 300 # keep idle threads 5 minutes around

executor = ThreadPoolExecutor.new(core_pool_size, maximum_pool_size, keep_alive_time, TimeUnit::SECONDS, LinkedBlockingQueue.new)

class CreateRandom 
  include Callable
  def call
    sleep 5
    return rand
  end
end

tasks = []


10.times do 
  task = FutureTask.new(CreateRandom.new)
  executor.execute(task)
  tasks << task
end

tasks.each do |t|
  puts t.get
end


# issue shutdown, otherwise the jvm keeps running until all threads are gone (-> never)
# shutdown wont terminate the jobs which are still running
executor.shutdown()