# frozen_string_literal: true

RSpec.describe Libexec::Exec do
  it "by_ls_1 dir got files" do
    expect(Libexec.by_ls_1("bin")).to eq %w[console setup]
  end

  it "by_ls_1 dir1, dir2 got dirs and files" do
    expect(Libexec.by_ls_1("bin", "sig")).to eq ["bin:", "console", "setup", "", "sig:", "libexec.rbs"]
  end

  it "by_ls_1 dir1/* got dirs/files" do
    expect(Libexec.by_ls_1("bin/*")).to eq ["bin/console", "bin/setup"]
  end

  it "each_ls_1 dir got files" do
    arr = []
    Libexec.each_ls_1 "bin" do |line|
      res = line.chomp.upcase
      p res
      arr.push res
    end

    expect(arr).to eq %w[CONSOLE SETUP]
  end

  it "each_ls_1 dir1, dir2 ignore some .chomp got files" do
    arr = []
    Libexec.each_ls_1 "bin", "sig" do |line|
      res = line.chomp
      ignore = res.end_with?(":") || res.empty?
      arr.push res unless ignore
    end

    expect(arr).to eq ["console", "setup", "libexec.rbs"]
  end
end
