class Gitflow < Formula
  desc "Git Flow workflow helper with interactive TUI and CLI"
  homepage "https://github.com/novaemx/gitflow-helper"
  url "https://github.com/novaemx/gitflow-helper/releases/download/v0.6.2/gitflow-0.6.2-darwin-universal.tar.gz"
  version "0.6.2"
  sha256 "adce8790cde0f069017b82302e093b8b40eabb41e38eb958ffe5da8017914c67"
  license "MIT"

  def install
    bin.install "gitflow"
  end

  test do
    output = shell_output("#{bin}/gitflow --version")
    assert_match version.to_s, output
  end
end
