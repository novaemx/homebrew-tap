class Treesize < Formula
  desc "Native macOS disk usage analyzer inspired by TreeSize"
  homepage "https://github.com/novaemx/treesize-mac"
  url "https://github.com/novaemx/treesize/releases/download/v0.1.14/treesize-0.1.14-darwin-universal.tar.gz"
  version "0.1.14"
  sha256 "a2e13e6e274649af01725106a62fb3f263dfeae6572da210c3585a8d18fcc8e6"
  license "MIT"

  def install
    bin.install "treesize-darwin-universal" => "treesize"
  end

  test do
    output = shell_output("#{bin}/treesize --version")
    assert_match version.to_s, output
  end
end
