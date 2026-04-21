# Homebrew Formula for gitflow-helper
# To install from tap: brew install <org>/tap/gitflow-helper
# To use locally: brew install --formula ./packaging/homebrew/gitflow-helper.rb
class GitflowHelper < Formula
  desc "Git Flow workflow helper — interactive TUI + CLI. Only requires git."
  homepage "https://github.com/novaemx/gitflow-helper"
  version "0.5.40"
  license "MIT"

  url "https://github.com/novaemx/gitflow-helper/releases/download/v0.5.40/gitflow-0.5.40-darwin-universal.tar.gz"
  sha256 "f83504e5dd54fd601aeecc68590017f2dec26ab76c51137e4e65733e115fd8e9"

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
