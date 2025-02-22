class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.5.13",
      revision: "841f938cc040baf814bbc61f2c5be85c5cf600e1"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6ffebdd16be520464b99472f049ae1f4c392649336e2447a29fa96c21dd8ea58" => :big_sur
    sha256 "b0beef138401e2cb814fdd05e8b926293252b6650acef8acf7cdf8259667f942" => :catalina
    sha256 "ed5a7e2ad66f510f3c00bac40af43569ac09dbd2be991484ab7e0c05d983e6bb" => :mojave
    sha256 "0d9a47920ebf2ac770c75ee50961f5da7541dbe92578a240d9d62170c2e1f402" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    system "make", "glooctl", "TAGGED_VERSION=v#{version}"
    bin.install "_output/glooctl"
  end

  test do
    run_output = shell_output("#{bin}/glooctl 2>&1")
    assert_match "glooctl is the unified CLI for Gloo.", run_output

    version_output = shell_output("#{bin}/glooctl version 2>&1")
    assert_match "Client: {\"version\":\"#{version}\"}", version_output

    version_output = shell_output("#{bin}/glooctl version 2>&1")
    assert_match "Server: version undefined", version_output

    # Should error out as it needs access to a Kubernetes cluster to operate correctly
    status_output = shell_output("#{bin}/glooctl get proxy 2>&1", 1)
    assert_match "failed to create kube client", status_output
  end
end
