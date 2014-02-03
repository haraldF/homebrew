require "formula"

class Ktexteditor < Formula
  homepage "http://www.kde.org/"
  url "http://download.kde.org/unstable/frameworks/4.95.0/ktexteditor-4.95.0.tar.xz"
  sha1 ""

  keg_only "Only required for building KDE applications"

  head 'git://anongit.kde.org/ktexteditor.git'

  depends_on "cmake" => :build
  depends_on "extra-cmake-modules" => :build
  depends_on "qt5" => :build
  depends_on "karchive" => :build
  depends_on "kjs" => :build
  depends_on "ki18n" => :build
  depends_on "kconfig" => :build
  depends_on "kguiaddons" => :build

  def install
    args = std_cmake_args
    args << "-DCMAKE_PREFIX_PATH=\"#{Formula.factory('qt5').opt_prefix};#{Formula.factory('extra-cmake-modules').opt_prefix}\""

    system "cmake", ".", *args
    system "make", "install"
  end
end
