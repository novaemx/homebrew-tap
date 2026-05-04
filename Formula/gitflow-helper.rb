class Gitflow < Formula
  desc "Git Flow workflow helper with interactive TUI and CLI"
  homepage "https://github.com/novaemx/gitflow-helper"
  url "https://github.com/novaemx/gitflow-helper/releases/download/v0.6.1/gitflow-0.6.1-darwin-universal.tar.gz"
  version "0.6.1"
  sha256 "31f1e3df14187e16255ad5d7bb4fdb3866f810b6fb8c541c502256b710bac255"
  license "MIT"

  def install
    bin.install "gitflow"
  end

  test do
    output = shell_output("#{bin}/gitflow --version")
    assert_match version.to_s, output
  end
end
