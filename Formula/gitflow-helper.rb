# Formula/gitflow-helper.rb
class GitflowHelper < Formula
  desc "Git Flow workflow helper — interactive TUI + CLI. Only requires git."
  homepage "https://github.com/novaemx/gitflow-helper"
  version "0.5.40"
  license "MIT"

  if Hardware::CPU.intel?
    url "https://github.com/novaemx/gitflow-helper/releases/download/v#{version}/gitflow-#{version}-darwin-universal.tar.gz"
    sha256 "1b8b62f54590cba5d5f9a3ccf0de043a5c48e3f95f74919a2023ba37d0d120cd"
  else
    url "https://github.com/novaemx/gitflow-helper/releases/download/v#{version}/gitflow-#{version}-darwin-universal.tar.gz"
    sha256 "1b8b62f54590cba5d5f9a3ccf0de043a5c48e3f95f74919a2023ba37d0d120cd"
  end

  def install
    bin.install "gitflow"
  end

  test do
    system "#{bin}/gitflow", "--version"
  end
end
