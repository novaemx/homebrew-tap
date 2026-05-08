class Treesize < Formula
  desc "Native macOS disk usage analyzer inspired by TreeSize"
  homepage "https://github.com/novaemx/treesize-mac"
  url "https://github.com/novaemx/treesize-mac/releases/download/v0.0.1/treesize-0.0.1-darwin-universal.tar.gz"
  version "0.0.1"
  sha256 "REPLACE_WITH_RELEASE_SHA256"
  license "MIT"

  def install
    bin.install "treesize-darwin-universal" => "treesize"
  end

  test do
    output = shell_output("#{bin}/treesize --version")
    assert_match version.to_s, output
  end
end
