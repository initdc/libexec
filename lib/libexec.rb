# frozen_string_literal: true

require_relative "libexec/version"
require_relative "libexec/exec"

module Libexec
  class Error < StandardError; end
  # Your code goes here...

  extend Libexec::Exec
end
