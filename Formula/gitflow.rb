class Gitflow < Formula
  desc "Git Flow workflow helper with interactive TUI and CLI"
  homepage "https://github.com/novaemx/gitflow-helper"
  url "https://github.com/novaemx/gitflow-helper/releases/download/v0.6.5/gitflow-0.6.5-darwin-universal.tar.gz"
  version "0.6.5"
  sha256 "d58d3635bffcacdbf8e9e9c70a5a6d1ce249b4dc09a5f0c662949c5f02d687a2"
  license "MIT"

  def install
    bin.install "gitflow"
  end

  test do
    output = shell_output("#{bin}/gitflow --version")
    assert_match version.to_s, output
  end
end
