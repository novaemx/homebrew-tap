class Treesize < Formula
  desc "Native macOS disk usage analyzer inspired by TreeSize"
  homepage "https://github.com/novaemx/treesize-mac"
  url "https://github.com/novaemx/treesize/releases/download/v0.1.7/treesize-0.1.7-darwin-universal.tar.gz"
  version "0.1.7"
  sha256 "7315c32c64294bbc007478363e702d7879d92debe60d0e16f1ce7e8dc1f0893b"
  license "MIT"

  def install
    bin.install "treesize-darwin-universal" => "treesize"
  end

  test do
    output = shell_output("#{bin}/treesize --version")
    assert_match version.to_s, output
  end
end
