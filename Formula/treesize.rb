class Treesize < Formula
  desc "Native macOS disk usage analyzer inspired by TreeSize"
  homepage "https://github.com/novaemx/treesize-mac"
  url "https://github.com/novaemx/treesize/releases/download/v0.1.8/treesize-0.1.8-darwin-universal.tar.gz"
  version "0.1.8"
  sha256 "19df5bc3be4116a8ce4b60254f1d1f032ef95c639ed647a624164fc53231f6c1"
  license "MIT"

  def install
    bin.install "treesize-darwin-universal" => "treesize"
  end

  test do
    output = shell_output("#{bin}/treesize --version")
    assert_match version.to_s, output
  end
end
