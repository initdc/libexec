# frozen_string_literal: true

RSpec.describe Libexec::Exec do
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
end
