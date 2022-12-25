# frozen_string_literal: true

module Libexec
  module Exec
    def run(cmd)
      # https://docs.ruby-lang.org/en/master/IO.html#method-c-popen
      IO.popen(cmd) do |pipe|
        print pipe.gets until pipe.eof?
      end
      nil
    end

    def each_line(cmd, &block)
      # https://docs.ruby-lang.org/en/master/IO.html#method-i-each_line
      IO.popen(cmd) do |pipe|
        pipe.each_line(&block)
      end
    end

    def by_ls_1(dir)
      arr = []
      each_line("ls -1 #{dir}") do |line|
        arr.push line.chomp
      end
      arr
    end

    def each_ls_1(dir, &block)
      each_line("ls -1 #{dir}", &block)
    end

    def code(cmd, *opt, **args)
      catch_error = !opt.empty? || args[:catch_error] || false
      code = opt[0] || args[:code] || 1

      # https://docs.ruby-lang.org/en/master/Process.html#method-c-last_status
      Process.spawn(cmd)
      Process.wait

      result = $?.exitstatus.zero?

      if catch_error && !result
        exit code
      else
        $?.exitstatus
      end
    rescue Errno::ENOENT => _e
      127
    end

    def output(cmd)
      # https://docs.ruby-lang.org/en/master/Kernel.html#method-i-60
      output = `#{cmd}`
      output.chomp
    end
  end
end
