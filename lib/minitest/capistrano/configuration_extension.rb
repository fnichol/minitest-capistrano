module MiniTest::Capistrano
  ##
  # Patches to Capistrano::Configuration to track invocations. Taken from
  # the awesome capistrano-spec gem
  # (https://github.com/technicalpickles/capistrano-spec)

  module ConfigurationExtension
    def get(remote_path, path, options={}, &block)
      gets[remote_path] = {:path => path, :options => options, :block => block}
    end

    def gets
      @gets ||= {}
    end

    def run(cmd, options={}, &block)
      runs[cmd] = {:options => options, :block => block}
    end

    def runs
      @runs ||= {}
    end

    def upload(from, to, options={}, &block)
      uploads[from] = {:to => to, :options => options, :block => block}
    end

    def uploads
      @uploads ||= {}
    end

    def put(data, path, options={})
      putes[path] = {:data => data, :options => options}
    end

    def putes
      @putes ||= {}
    end

    def capture(command, options={})
      captures[command] = {:options => options}
      captures_responses[command]
    end

    def captures
      @captures ||= {}
    end

    def captures_responses
      @captures_responses ||= {}
    end

    def find_callback(on, task)
      task = find_task(task) if task.kind_of?(String)

      Array(callbacks[on]).select do |task_callback|
        task_callback.applies_to?(task) ||
          task_callback.source == task.fully_qualified_name
      end
    end
  end
end

