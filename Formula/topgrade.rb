class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/r-darwish/topgrade"
  url "https://github.com/r-darwish/topgrade/archive/v6.0.2.tar.gz"
  sha256 "c06ebb0e2c4b2b49751c4ba7cfb8ce4ec7fe2f9247faac3edd4256c215c8bfba"
  license "GPL-3.0-or-later"

  bottle do
    cellar :any_skip_relocation
    sha256 "1a45d9656f819e083864dbbf06f10294079e92e2a33e42cbb69f8fe34db66d16" => :big_sur
    sha256 "20ce7d05271966961f32fd96a567e00d1b8f2e72e54118883bb39b3e0ee40341" => :catalina
    sha256 "2cb05a71a0df0049af0a9fbd46a1423a75a7f06d84c603dabbacce35a2e54dc2" => :mojave
    sha256 "0a3919b5d3381b143bdc6931b5b56490f3e6cfbed11b3d711e3ebf948128d15a" => :x86_64_linux
  end

  depends_on "rust" => :build
  depends_on xcode: :build if MacOS::CLT.version >= "11.4" # libxml2 module bug

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Configuraton path details: https://github.com/r-darwish/topgrade/blob/HEAD/README.md#configuration-path
    # Sample config file: https://github.com/r-darwish/topgrade/blob/HEAD/config.example.toml
    (testpath/"Library/Preferences/topgrade.toml").write <<~EOS
      # Additional git repositories to pull
      #git_repos = [
      #    "~/src/*/",
      #    "~/.config/something"
      #]
    EOS

    assert_match version.to_s, shell_output("#{bin}/topgrade --version")

    output = shell_output("#{bin}/topgrade -n --only brew")
    assert_match "Dry running: #{HOMEBREW_PREFIX}/bin/brew upgrade", output
    assert_not_match /\sSelf update\s/, output
  end
end
