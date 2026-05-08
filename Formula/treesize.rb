class Treesize < Formula
  desc "Native macOS disk usage analyzer inspired by TreeSize"
  homepage "https://github.com/novaemx/treesize-mac"
  url "https://github.com/novaemx/treesize/releases/download/v0.1.16/treesize-0.1.16-darwin-universal.tar.gz"
  version "0.1.16"
  sha256 "25a433c6b5a18fbbe1e6367ee37da3625c5720eb083562d512d6c32e2313e120"
  license "MIT"

  def install
    bin.install "treesize-darwin-universal" => "treesize"
  end

  test do
    output = shell_output("#{bin}/treesize --version")
    assert_match version.to_s, output
  end
end
