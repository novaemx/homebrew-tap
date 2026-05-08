class Treesize < Formula
  desc "Native macOS disk usage analyzer inspired by TreeSize"
  homepage "https://github.com/novaemx/treesize-mac"
  url "https://github.com/novaemx/treesize/releases/download/v0.1.9/treesize-0.1.9-darwin-universal.tar.gz"
  version "0.1.9"
  sha256 "d7ff73d54facc904413c9a3e9abadddc17fb35700a793d0477538a349f1838e5"
  license "MIT"

  def install
    bin.install "treesize-darwin-universal" => "treesize"
  end

  test do
    output = shell_output("#{bin}/treesize --version")
    assert_match version.to_s, output
  end
end
