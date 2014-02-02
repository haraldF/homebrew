require "formula"

class Kguiaddons < Formula
  homepage "http://www.kde.org/"
  url "http://download.kde.org/unstable/frameworks/4.95.0/kguiaddons-4.95.0.tar.xz"
  sha1 "8e9689f3bb978194788d0801325b2a4045cfd9d4"

  keg_only "Only required for building KDE applications"

  head 'git://anongit.kde.org/kguiaddons.git'

  depends_on "cmake" => :build
  depends_on "extra-cmake-modules" => :build
  depends_on "qt5" => :build

  def install
    args = std_cmake_args
    args << "-DCMAKE_PREFIX_PATH=\"#{Formula.factory('qt5').opt_prefix};#{Formula.factory('extra-cmake-modules').opt_prefix}\""
    args << "-DCMAKE_PREFIX_PATH="

    system "cmake", ".", *args
    system "make", "install"
  end
end
