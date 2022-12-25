# frozen_string_literal: true

RSpec.describe Libexec::Exec do
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
end
