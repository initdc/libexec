# frozen_string_literal: true

RSpec.describe Libexec::Exec do
  it 'run("uname") got nil' do
    expect(Libexec.run("uname")).to be nil
  end

  it 'run("uname") $stdout got "Linux\n"' do
    output = with_captured_stdout do
      Libexec.run("uname")
    end

    expect(output).to eq "Linux\n"
  end

  it 'run("sudo apt-get update") print line by line' do
    expect(Libexec.run("sudo apt-get update")).to be nil
  end

  it 'run("ls -1 bin") $stdout got "console\nsetup\n"' do
    output = with_captured_stdout do
      Libexec.run("ls -1 bin")
    end

    expect(output).to eq "console\nsetup\n"
  end

  it 'run("ls", %w[-1 bin]) $stdout got "console\nsetup\n"' do
    output = with_captured_stdout do
      Libexec.run("ls", %w[-1 bin])
    end

    expect(output).to eq "console\nsetup\n"
  end

  it 'run("ls", "-1", %w[bin]) $stdout got "console\nsetup\n"' do
    output = with_captured_stdout do
      Libexec.run("ls", "-1", %w[bin])
    end

    expect(output).to eq "console\nsetup\n"
  end

  it 'run("ls", %w[-1], "bin") $stdout got "console\nsetup\n"' do
    output = with_captured_stdout do
      Libexec.run("ls", %w[-1], "bin")
    end

    expect(output).to eq "console\nsetup\n"
  end

  it 'each_line("ls -1 bin") |li| {li.chomp} got %w[console setup]' do
    arr = []
    Libexec.each_line("ls -1 bin") do |line|
      res = line.chomp
      p res
      arr.push res
    end

    expect(arr).to eq %w[console setup]
  end

  it 'each_line("ls", %w[-1 bin]) |li| {li.chomp} got %w[console setup]' do
    arr = []
    Libexec.each_line("ls", %w[-1 bin]) do |line|
      res = line.chomp
      p res
      arr.push res
    end

    expect(arr).to eq %w[console setup]
  end
end
