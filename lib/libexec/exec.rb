# frozen_string_literal: true

module Libexec
  module Exec
    # wrapper for Ruby IO.popen
    # {https://docs.ruby-lang.org/en/master/IO.html#method-c-popen link} <br>
    # cmd first grammar <br>
    # conv argv by _ruby_style_cmd
    #
    # @return [nil]
    def run(*argv, env: {}, mode: "r", **opts)
      cmd = _ruby_style_cmd(argv)

      IO.popen(env, cmd, mode, opts) do |pipe|
        print pipe.gets until pipe.eof?
      end
      nil
    end

    # Run code block in IO.popen <br>
    # inspired from Ruby IO.each_line
    # {https://docs.ruby-lang.org/en/master/IO.html#method-i-each_line link}
    def each_line(*argv, env: {}, mode: "r", **opts, &block)
      cmd = _ruby_style_cmd(argv)

      IO.popen(env, cmd, mode, opts) do |pipe|
        pipe.each_line(&block)
      end
    end

    # wrapper for `ls -1` which will be often used
    #
    # @param  [Array] argv
    # @return [Array] line.chomp
    def by_ls_1(*argv, **opts)
      arr = []
      each_line("ls", "-1", argv, opts: opts) do |line|
        arr.push line.chomp
      end
      arr
    end

    # Operate each line result by yourself in `ls -1`
    #
    # @param [Array] argv
    def each_ls_1(*argv, **opts, &block)
      each_line("ls", "-1", argv, opts: opts, &block)
    end

    # wrapper for Process.spawn
    # {https://docs.ruby-lang.org/en/master/Process.html#method-c-last_status link}
    #
    # @return [Integer]
    def code(*argv, **opts)
      catch_error = opts[:catch_error]
      code = opts[:code]

      if argv.size < 2
        catch_error ||= false
        code ||= 1

        cmd = _js_style_cmd(argv)
      else
        is_integer = argv.last.instance_of?(Integer)

        catch_error ||= is_integer
        code ||= (argv.last if is_integer) || 1

        args = argv.clone
        args.pop
        cmd = is_integer ? _js_style_cmd(args) : _js_style_cmd(argv)
      end

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

    # wrapper for Kernel.`command`
    # {https://docs.ruby-lang.org/en/master/Kernel.html#method-i-60 link}
    #
    # @note Only recommend to use when get single line output
    # @return [String] output.chomp
    def output(*argv)
      cmd = _js_style_cmd(argv)

      output = `#{cmd}`
      output.chomp
    end

    private

    # cmd must be unix command String <br>
    # no " ", not Array <br>
    # not support cmd with opt like `ls -1`
    #
    # @param [Array] argv
    # @return [String | Array]
    #
    # @since 0.2.1
    def _ruby_style_cmd(argv)
      cmd, *args = argv

      unless args.empty?
        arr = [cmd]
        args.each do |arg|
          # https://docs.ruby-lang.org/en/master/Kernel.html#method-i-class
          if arg.instance_of?(Array)
            arr.concat(arg)
          elsif arg.instance_of?(String)
            arr.push(arg)
          end
        end
        cmd = arr
      end
      cmd
    end

    # in JS style, all arg connect with " " <br>
    # so cmd like `ls -1` is OK
    #
    # @param [Array] argv
    # @return [String | Array]
    #
    # @since 0.2.1
    def _js_style_cmd(argv)
      cmd, *args = argv

      unless args.empty?
        arr = [cmd]
        args.each do |arg|
          if arg.instance_of?(Array)
            arr.push(%('#{arg.join(" ")}'))
          elsif arg.instance_of?(String)
            arr.push(arg)
          end
        end
        cmd = arr.join(" ")
      end
      cmd
    end
  end
end
