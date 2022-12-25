# frozen_string_literal: true

RSpec.describe Libexec::Exec do
  it 'output("uname") got "Linux"' do
    expect(Libexec.output("uname")).to eq "Linux"
  end

  it 'output("ls -1 bin") got "console\nsetup"' do
    expect(Libexec.output("ls -1 bin")).to eq "console\nsetup"
  end

  it 'output("cd bin; echo *") got "console setup"' do
    expect(Libexec.output("cd bin; echo *")).to eq "console setup"
  end

  it 'output("echo", ["*"]) got "*"' do
    expect(Libexec.output("echo", ["*"])).to eq "*"
  end

  it 'output("echo", %w[Hello World]) got "Hello World"' do
    expect(Libexec.output("echo", %w[Hello World])).to eq "Hello World"
  end

  it 'output("echo", %w[Hello], "World") got "Hello World"' do
    expect(Libexec.output("echo", %w[Hello], "World")).to eq "Hello World"
  end

  it 'output("echo", "Hello", "World") got "Hello World"' do
    expect(Libexec.output("echo", "Hello", "World")).to eq "Hello World"
  end

  it 'output("cd bin; ls -1 *") got "console\nsetup"' do
    expect(Libexec.output("cd bin; ls -1 *")).to eq "console\nsetup"
  end

  it 'output("cd bin;", "ls -1 *") got "console\nsetup"' do
    expect(Libexec.output("cd bin;", "ls -1 *")).to eq "console\nsetup"
  end

  it 'output("cd bin;", "ls -1", "*") got "console\nsetup"' do
    expect(Libexec.output("cd bin;", "ls -1", "*")).to eq "console\nsetup"
  end
end
