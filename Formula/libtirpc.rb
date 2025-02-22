class Libtirpc < Formula
  desc "Port of Sun's Transport-Independent RPC library to Linux"
  homepage "https://sourceforge.net/projects/libtirpc/"
  url "https://downloads.sourceforge.net/project/libtirpc/libtirpc/1.3.1/libtirpc-1.3.1.tar.bz2"
  sha256 "245895caf066bec5e3d4375942c8cb4366adad184c29c618d97f724ea309ee17"
  license "BSD-3-Clause"

  bottle do
    cellar :any_skip_relocation
    sha256 "4c3795f5740fa28ce7f1dbdf5eb96a5c96d7e1d085408c25c8b4507e07303055" => :x86_64_linux
  end

  depends_on "krb5"
  depends_on :linux

  def install
    system "./configure",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <rpc/des_crypt.h>
      #include <stdio.h>
      int main () {
        char key[] = "My8digitkey1234";
        if (sizeof(key) != 16)
          return 1;
        des_setparity(key);
        printf("%lu\\n", sizeof(key));
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-I#{include}/tirpc", "-ltirpc", "-o", "test"
    system "./test"
  end
end
