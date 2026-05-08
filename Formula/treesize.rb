class Treesize < Formula
  desc "Native macOS disk usage analyzer inspired by TreeSize"
  homepage "https://github.com/novaemx/treesize-mac"
  url "https://github.com/novaemx/treesize/releases/download/v0.1.10/treesize-0.1.10-darwin-universal.tar.gz"
  version "0.1.10"
  sha256 "0c9f9893111deccf3efe453f564023b28f9ea3e90396fd9e8bfc0c315302041d"
  license "MIT"

  def install
    bin.install "treesize-darwin-universal" => "treesize"
  end

  test do
    output = shell_output("#{bin}/treesize --version")
    assert_match version.to_s, output
  end
end
