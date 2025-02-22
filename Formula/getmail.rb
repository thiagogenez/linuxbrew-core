class Getmail < Formula
  desc "Extensible mail retrieval system with POP3, IMAP4, SSL support"
  homepage "http://pyropus.ca/software/getmail/"
  url "http://pyropus.ca/software/getmail/old-versions/getmail-5.14.tar.gz"
  sha256 "f3a99fe74564237d12ca8d4582e113c067c9205b5ab640f72b4e8447606a99c1"

  livecheck do
    url :homepage
    regex(/href=.*?getmail[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "f8b68c2c3d3245e6ef4a7bdb7bec68a7c12cc990a6455f3dd543822dda5573ce" => :big_sur
    sha256 "571bce56f171a3ea5274bdcb3aaac6bb18dc20323ccee9e513ca14d15f7b75f0" => :catalina
    sha256 "bc414cc8a0f41c10adea2fe326d90567ed5fb143db7a4030db72c40c94f816d5" => :mojave
    sha256 "bc414cc8a0f41c10adea2fe326d90567ed5fb143db7a4030db72c40c94f816d5" => :high_sierra
    sha256 "d6a5a3c48f35d407c0a221da9c94e5ca8a92beac14c26aa13d4d355dfd64c923" => :sierra
    sha256 "5831ea59e991a117a04bdefeedc5a0df51c2caf115191ea2dc1dd941561c1cc5" => :x86_64_linux
  end

  def install
    libexec.install %w[getmail getmail_fetch getmail_maildir getmail_mbox]
    inreplace Dir[libexec/"*"], %r{^#!/usr/bin/env python$}, "#!/usr/bin/python"
    bin.install_symlink Dir["#{libexec}/*"]
    libexec.install "getmailcore"
    man1.install Dir["docs/*.1"]
  end

  test do
    system bin/"getmail", "--help"
  end
end
