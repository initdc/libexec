# frozen_string_literal: true

RSpec.describe Libexec do
  it "has a version number" do
    expect(Libexec::VERSION).not_to be nil
  end

  it "Process.last_status got nil" do
    result = Process.last_status

    expect(result).to be nil
  end

  it "run cmd got nil" do
    expect(Libexec.run("uname")).to be nil
  end

  it "run cmd print line by line" do
    expect(Libexec.run("sudo apt-get update")).to be nil
  end

  it "code cmd got 0" do
    expect(Libexec.code("uname")).to eq 0
  end

  it "code cmd got 127" do
    expect(Libexec.code("unamea")).to eq 127
  end

  it "code cmd got 1" do
    expect(Libexec.code("exit 1")).to eq 1
  end

  it "code cmd got exit 99" do
    # https://docs.ruby-lang.org/en/master/Process.html#method-c-wait
    Process.fork { Libexec.code("exit 99", 99) }
    Process.wait

    expect($?.exitstatus).to eq 99
  end

  it "each_line cmd got array" do
    arr = []
    Libexec.each_line "ls -1 bin" do |line|
      res = line.chomp
      p res
      arr.push res
    end

    expect(arr).to eq %w[console setup]
  end

  it "by_ls_1 dir got array" do
    expect(Libexec.by_ls_1("bin")).to eq %w[console setup]
  end

  it "each_line cmd got array" do
    arr = []
    Libexec.each_ls_1 "bin" do |line|
      res = line.chomp.upcase
      p res
      arr.push res
    end

    expect(arr).to eq %w[CONSOLE SETUP]
  end

  it "output cmd got 'Linux'" do
    expect(Libexec.output("uname")).to eq "Linux"
  end

  it "can be extend as class method" do
    class MyClass
      extend Libexec::Exec
    end

    expect(MyClass.output("uname")).to eq "Linux"
  end

  it "can be include as instance method" do
    class MyClass
      include Libexec::Exec
    end

    m = MyClass.new
    expect(m.output("uname")).to eq "Linux"
  end

  it "can be extend and be include" do
    class MyClass
      extend Libexec::Exec
      include Libexec::Exec
    end

    expect(MyClass.output("uname")).to eq "Linux"

    m = MyClass.new
    expect(m.output("uname")).to eq "Linux"
  end
end
