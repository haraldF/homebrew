require "formula"

class Kjobwidgets < Formula
  homepage "http://www.kde.org/"
  url "http://download.kde.org/unstable/frameworks/4.95.0/kjobwidgets-4.95.0.tar.xz"
  sha1 "2d2c66e7f84dc5a180945150c90ae6e08cb78e98"

  keg_only "Only required for building KDE applications"

  head 'git://anongit.kde.org/kjobwidgets.git'

  depends_on "cmake" => :build
  depends_on "extra-cmake-modules" => :build
  depends_on "qt5" => :build

  def install
    args = std_cmake_args
    args << "-DCMAKE_PREFIX_PATH=\"#{Formula.factory('qt5').opt_prefix};#{Formula.factory('extra-cmake-modules').opt_prefix}\""

    system "cmake", ".", *args
    system "make", "install"
  end
end
