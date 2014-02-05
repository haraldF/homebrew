require "formula"

class Kf5umbrella < Formula
  homepage "http://www.kde.org/"
  url "http://download.kde.org/unstable/frameworks/4.95.0/kf5umbrella-4.95.0.tar.xz"
  sha1 "5b7ed9d1e0007926d9d1a4752105e4602bc5addd"

  keg_only "Only required for building KDE frameworks"

  head 'git://anongit.kde.org/kf5umbrella.git'

  depends_on "cmake" => :build
  depends_on "extra-cmake-modules" => :build
  depends_on "qt5" => :build

  def install
    args = std_cmake_args
    args << "-DCMAKE_PREFIX_PATH=#{Formula.factory('qt5').opt_prefix}"

    system "cmake", ".", *args
    system "make", "install"
  end
end
