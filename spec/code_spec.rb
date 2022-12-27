# frozen_string_literal: true

RSpec.describe Libexec::Exec do
  it 'code("uname") got 0' do
    expect(Libexec.code("uname")).to eq 0
  end

  it 'code("unamea") got 127' do
    expect(Libexec.code("unamea")).to eq 127
  end

  it 'code("exit 0") got 0' do
    expect(Libexec.code("exit 0")).to eq 0
  end

  it 'code("exit") got 0' do
    expect(Libexec.code("exit")).to eq 0
  end

  it 'code("exit 1") got 1' do
    expect(Libexec.code("exit 1")).to eq 1
  end

  it 'code("exit", "2") got 2' do
    expect(Libexec.code("exit", "2")).to eq 2
  end

  it 'code("exit", "3") got 3' do
    expect(Libexec.code("exit", "3")).to eq 3
  end

  it 'code("exit", ["3"]) got 3' do
    expect(Libexec.code("exit", ["3"])).to eq 3
  end

  it 'code("exit", "4 5") got 4' do
    expect(Libexec.code("exit", "4 5")).to eq 4
  end

  it 'code("exit", %w[4 5]) got 2' do
    expect(Libexec.code("exit", %w[4 5])).to eq 2
  end

  it 'code("exit 0", 45) got 0' do
    expect(Libexec.code("exit 0", 45)).to eq 0
  end

  it 'code("exit 1", 6) got 6' do
    # https://docs.ruby-lang.org/en/master/Process.html#method-c-wait
    Process.fork { Libexec.code("exit 1", 6) }
    Process.wait

    expect($?.exitstatus).to eq 6
  end

  it 'code("exit", ["1"], 99' do
    # https://docs.ruby-lang.org/en/master/Process.html#method-c-wait
    Process.fork { Libexec.code("exit", ["1"], 99) }
    Process.wait

    expect($?.exitstatus).to eq 99
  end
end
