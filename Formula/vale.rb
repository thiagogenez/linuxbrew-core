class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://errata-ai.github.io/vale/"
  url "https://github.com/errata-ai/vale/archive/v2.6.6.tar.gz"
  sha256 "86efac2a5701499f8829efb945f513aa978a8efd6ffac686985ef1c5f0306b79"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "89e8c351c44bd644ebc2ab38dcd1be0159f6ee5062f0cdd20db34ef29b0aba26" => :big_sur
    sha256 "fc1098ae217848ec4adcab7cbc85480106bdef79adfd22059848e52757b6967f" => :catalina
    sha256 "800517125fd7f185d3df41f4f657edc9656f0e497293520c1a6cb33f3531b3f6" => :mojave
    sha256 "edafbaf5febae5906908a0bfb5a1010747c2ab3c92d63855cceb640f1fe7a8ec" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.version=#{version} -s -w"
    system "go", "build", *std_go_args, "-ldflags=#{ldflags}"
  end

  test do
    mkdir_p "styles/demo"
    (testpath/"styles/demo/HeadingStartsWithCapital.yml").write <<~EOS
      extends: capitalization
      message: "'%s' should be in title case"
      level: warning
      scope: heading.h1
      match: $title
    EOS

    (testpath/"vale.ini").write <<~EOS
      StylesPath = styles
      [*.md]
      BasedOnStyles = demo
    EOS

    (testpath/"document.md").write("# heading is not capitalized")

    output = shell_output("#{bin}/vale --config=#{testpath}/vale.ini #{testpath}/document.md 2>&1")
    assert_match(/✖ .*0 errors.*, .*1 warning.* and .*0 suggestions.* in 1 file\./, output)
  end
end
