# frozen_string_literal: true

RSpec.describe Libexec do
  it "has a version number" do
    expect(Libexec::VERSION).not_to be nil
  end

  # it "Process.last_status got nil" do
  #   result = Process.last_status

  #   expect(result).to be nil
  # end

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
