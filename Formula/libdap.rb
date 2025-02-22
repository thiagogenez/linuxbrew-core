class Libdap < Formula
  desc "Framework for scientific data networking"
  homepage "https://www.opendap.org/"
  url "https://www.opendap.org/pub/source/libdap-3.20.6.tar.gz"
  sha256 "35cc7f952d72de4936103e8a95c67ac8f9b855c9211fae73ad065331515cc54a"
  license "LGPL-2.1"

  livecheck do
    url "https://www.opendap.org/pub/source/"
    regex(/href=.*?libdap[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 "bc3f88998c1d144671ea9ab590e5bb618236d33bcd33c7350fb9e3dfae041a84" => :big_sur
    sha256 "6a0bbd25fd0b5e873d34a46045c6ba72161007b9937d7957790bfc16bf5b05c3" => :catalina
    sha256 "ce373bf6fbe4f5b28825fcf243633ae7a807d35b1627e985cc231bc722010793" => :mojave
    sha256 "fbaa33ce89105a9cab0a7d8b22755524a93f39fb2a8e6d3c5a0459c2ded3bdf5" => :high_sierra
    sha256 "45a4a00eb02faf6335cebd5d726d72c5ea9e5a75ef3843ab6b6101b33ce0c010" => :x86_64_linux
  end

  head do
    url "https://github.com/OPENDAP/libdap4.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  # error: 'max_align_t' has a previous declaration when using gcc 4.8
  fails_with gcc: "4.8" unless OS.mac?

  depends_on "bison" => :build
  depends_on "pkg-config" => :build
  depends_on "libxml2"
  depends_on "openssl@1.1"

  uses_from_macos "flex" => :build
  uses_from_macos "curl"

  on_linux do
    depends_on "util-linux"
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-debug
      --with-included-regex
    ]

    system "autoreconf", "-fvi" if build.head?
    system "./configure", *args
    system "make"
    system "make", "check"
    system "make", "install"

    # Ensure no Cellar versioning of libxml2 path in dap-config entries
    xml2 = Formula["libxml2"]
    inreplace bin/"dap-config", xml2.opt_prefix.realpath, xml2.opt_prefix
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dap-config --version")
  end
end
