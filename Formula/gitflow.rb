class Gitflow < Formula
  desc "Git Flow workflow helper with interactive TUI and CLI"
  homepage "https://github.com/novaemx/gitflow-helper"
  url "https://github.com/novaemx/gitflow-helper/releases/download/v0.6.4/gitflow-0.6.4-darwin-universal.tar.gz"
  version "0.6.4"
  sha256 "b45e9039b0db460a98948425837ebc569685fd5276c605c7a6b50be5713fbe8c"
  license "MIT"

  def install
    bin.install "gitflow"
  end

  test do
    output = shell_output("#{bin}/gitflow --version")
    assert_match version.to_s, output
  end
end
