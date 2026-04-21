# Homebrew Formula for gitflow-helper
# To install from tap: brew install <org>/tap/gitflow-helper
# To use locally: brew install --formula ./packaging/homebrew/gitflow-helper.rb
class GitflowHelper < Formula
  desc "Git Flow workflow helper — interactive TUI + CLI. Only requires git."
  homepage "https://github.com/novaemx/gitflow-helper"
  version "0.5.40"
  license "MIT"

  url "https://github.com/novaemx/gitflow-helper/releases/download/v0.5.40/gitflow-0.5.40-darwin-universal.tar.gz"
  sha256 "5abf08a5bd7ab3cc59d3871023db3e4cff9817a1c5f6cf71be41736ba9118cef"

  depends_on "git"

  def install
    bin.install "gitflow"
    (bash_completion/"gitflow").write `#{bin}/gitflow completion bash`
    (zsh_completion/"_gitflow").write `#{bin}/gitflow completion zsh`
    (fish_completion/"gitflow.fish").write `#{bin}/gitflow completion fish`
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitflow --version")
    assert_match "bash", shell_output("#{bin}/gitflow completion --help")
  end
end
