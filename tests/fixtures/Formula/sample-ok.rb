class SampleOk < Formula
  desc "Sample formula"
  homepage "https://example.com/sample-ok"
  version "1.2.3"
  url "https://example.com/downloads/sample-ok-1.2.3.tar.gz"
  sha256 "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"

  def install
    bin.install "sample-ok"
  end
end
