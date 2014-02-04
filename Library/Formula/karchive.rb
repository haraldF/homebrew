require "formula"

class Karchive < Formula
  homepage "http://www.kde.org/"
  url "http://download.kde.org/unstable/frameworks/4.95.0/karchive-4.95.0.tar.xz"
  sha1 "348bd05ab2fd0a533688e0eefd62ea9fc0bf79d7"

  head 'git://anongit.kde.org/karchive.git'

  depends_on "cmake" => :build
  depends_on "extra-cmake-modules" => :build
  depends_on "qt5"

  def patches
    DATA
  end

  def install
    args = std_cmake_args
    args << "-DCMAKE_PREFIX_PATH=\"#{Formula.factory('qt5').opt_prefix};#{Formula.factory('extra-cmake-modules').opt_prefix}\""

    system "cmake", ".", *args
    system "make", "install"
  end
end

__END__
diff --git a/autotests/karchivetest.cpp b/autotests/karchivetest.cpp
index 6d6b584..5adda2f 100644
--- a/autotests/karchivetest.cpp
+++ b/autotests/karchivetest.cpp
@@ -32,6 +32,13 @@
 #include <unistd.h> // symlink
 #include <errno.h>
 #endif
+#ifdef Q_OS_MAC
+extern "C"
+{
+    ssize_t readlink(const char *path, char *buf, size_t bufsize);
+    int symlink(const char *path1, const char *path2);
+}
+#endif
 
 #ifdef Q_OS_WIN
 #include <Windows.h>
diff --git a/src/karchive.cpp b/src/karchive.cpp
index a25b85e..8d054d2 100644
--- a/src/karchive.cpp
+++ b/src/karchive.cpp
@@ -48,6 +48,9 @@
 #ifdef Q_OS_WIN
 #include <Windows.h> // DWORD, GetUserNameW
 #endif // Q_OS_WIN
+#ifdef Q_OS_MACX
+extern "C" { ssize_t readlink(const char *path, char *buf, size_t bufsize); }
+#endif
 
 ////////////////////////////////////////////////////////////////////////
 /////////////////////////// KArchive ///////////////////////////////////
