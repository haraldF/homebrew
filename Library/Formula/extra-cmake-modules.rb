require "formula"

class ExtraCmakeModules < Formula
  homepage "http://www.kde.org/"
  url "http://download.kde.org/unstable/frameworks/4.95.0/extra-cmake-modules-0.0.9.tar.xz"
  sha1 "dcdf6240b9fd7f1e6be390435f5aa70d804c914a"

  keg_only "Only required for building KDE frameworks"

  head 'git://anongit.kde.org/extra-cmake-modules'

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end
end
