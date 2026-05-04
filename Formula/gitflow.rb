class Gitflow < Formula
  desc "Git Flow workflow helper with interactive TUI and CLI"
  homepage "https://github.com/novaemx/gitflow-helper"
  url "https://github.com/novaemx/gitflow-helper/releases/download/v0.6.1/gitflow-0.6.1-darwin-universal.tar.gz"
  version "0.6.1"
  sha256 "01997bd735be49a75333836c86a230a7381a59455059bb529aa21a8682a4cd3f"
  license "MIT"

  def install
    bin.install "gitflow"
  end

  test do
    output = shell_output("#{bin}/gitflow --version")
    assert_match version.to_s, output
  end
end
