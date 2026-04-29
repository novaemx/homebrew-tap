class SampleBad < Formula
  desc "Bad sample formula"
  homepage "https://example.com/sample-bad"
  version "2.0.0"
  url "https://example.com/downloads/sample-bad-9.9.9.tar.gz"
  sha256 "bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb"

  def install
    bin.install "sample-bad"
  end
end
