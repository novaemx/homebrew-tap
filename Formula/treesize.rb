class Treesize < Formula
  desc "Native macOS disk usage analyzer inspired by TreeSize"
  homepage "https://github.com/novaemx/treesize-mac"
  url "https://github.com/novaemx/treesize/releases/download/v0.1.15/treesize-0.1.15-darwin-universal.tar.gz"
  version "0.1.15"
  sha256 "8c7f4a1a93e98c8b1b6650ff86fd2db61dc0604b3a8c54fef8808d776948d2e2"
  license "MIT"

  def install
    bin.install "treesize-darwin-universal" => "treesize"
  end

  test do
    output = shell_output("#{bin}/treesize --version")
    assert_match version.to_s, output
  end
end
