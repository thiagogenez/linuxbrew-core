class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v2.15.4",
      revision: "d804b7d99c476134480e723c93d53c4454891293"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f56996a56fc691c393faa9a8402d98bbf15eba4b7b155d647b08d0bf35f5ef92" => :big_sur
    sha256 "51d8bd3bc059c0c9be5d1e7441d026d6bf2a569d74291956a1676665f57fe434" => :catalina
    sha256 "0169b96b1258b7d54f9f90f1e5adcb0acae918718055c3154c66727e33fd1e64" => :mojave
    sha256 "e040d1716b3b0373327f6d41e50bffdd8c393dc2a12ac82b955336e4e8862626" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    cd "./sdk" do
      system "go", "mod", "download"
    end
    cd "./pkg" do
      system "go", "mod", "download"
    end

    system "make", "brew"

    bin.install Dir["#{ENV["GOPATH"]}/bin/pulumi*"]

    # Install shell completions
    (bash_completion/"pulumi.bash").write Utils.safe_popen_read(bin/"pulumi", "gen-completion", "bash")
    (zsh_completion/"_pulumi").write Utils.safe_popen_read(bin/"pulumi", "gen-completion", "zsh")
    (fish_completion/"pulumi.fish").write Utils.safe_popen_read(bin/"pulumi", "gen-completion", "fish")
  end

  test do
    ENV["PULUMI_ACCESS_TOKEN"] = "local://"
    ENV["PULUMI_TEMPLATE_PATH"] = testpath/"templates"
    system "#{bin}/pulumi", "new", "aws-typescript", "--generate-only",
                                                     "--force", "-y"
    assert_predicate testpath/"Pulumi.yaml", :exist?, "Project was not created"
  end
end
