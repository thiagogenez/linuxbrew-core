class Rgbds < Formula
  desc "Rednex GameBoy Development System"
  homepage "https://github.com/rednex/rgbds"
  url "https://github.com/rednex/rgbds/archive/v0.4.1.tar.gz"
  sha256 "cecee415a3fafe56a761f033ffbf6c6aa6af1e47dc2b764ffd04104897bbd2e5"
  license "MIT"
  head "https://github.com/rednex/rgbds.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any
    sha256 "1e6c364d0a654e124aa5cae514bb5f64e69af66f63254a272a473de7db3077c9" => :big_sur
    sha256 "8adee69ec949c97750ea1aa84fb7ccabe219598902744f06cae3b49b4cbe6a08" => :catalina
    sha256 "22b389095a057f515398cfa7981339fb37f93cf12417c1c9ff3fac9bc31cc71c" => :mojave
    sha256 "a791dd97949a7aec4d02197bfdd44ee6bd84472c93a50d6b762b5a3a2f2c5117" => :high_sierra
    sha256 "1bac89ad73deeb348f61cf0e6cf83741e676a71b398df430bd1d851ea4a859d0" => :x86_64_linux
  end

  depends_on "pkg-config" => :build
  depends_on "libpng"

  uses_from_macos "bison" => :build

  def install
    system "make", "install", "PREFIX=#{prefix}", "mandir=#{man}"
  end

  test do
    # https://github.com/rednex/rgbds/blob/HEAD/test/asm/assert-const.asm
    (testpath/"source.asm").write <<~EOS
      SECTION "rgbasm passing asserts", ROM0[0]
        db 0
        assert @
    EOS
    system "#{bin}/rgbasm", "source.asm"
  end
end
