require "formula"

class Kcoreaddons < Formula
  homepage "http://www.kde.org/"
  url "http://download.kde.org/unstable/frameworks/4.95.0/kcoreaddons-4.95.0.tar.xz"
  sha1 "5fc12b08e4d1707a68548ac4f002647f7bf7bceb"

  keg_only "Only required for building KDE applications"

  head 'git://anongit.kde.org/kcoreaddons.git'

  depends_on "cmake" => :build
  depends_on "extra-cmake-modules" => :build
  depends_on "qt5" => :build
  depends_on "shared-mime-info"

  def patches
      DATA
  end

  def install
    args = std_cmake_args
    args << "-DCMAKE_PREFIX_PATH=\"#{Formula.factory('qt5').opt_prefix};#{Formula.factory('extra-cmake-modules').opt_prefix}\""
    args << "-DCMAKE_CXX_FLAGS='-D_DARWIN_C_SOURCE'"

    system "cmake", ".", *args
    system "make", "install"
  end
end

__END__
diff --git a/src/lib/util/kformatprivate.cpp b/src/lib/util/kformatprivate.cpp
index 06a6088..6f2a890 100644
--- a/src/lib/util/kformatprivate.cpp
+++ b/src/lib/util/kformatprivate.cpp
@@ -26,6 +26,8 @@
 
 #include <QDateTime>
 
+#include <math.h>
+
 KFormatPrivate::KFormatPrivate(const QLocale &locale)
 {
     m_locale = locale;
