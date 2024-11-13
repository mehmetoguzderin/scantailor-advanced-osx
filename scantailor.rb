class Scantailor < Formula
  desc "ScanTailor Advanced: Postprocessing for Book Scans"
  homepage "https://github.com/ScanTailor-Advanced/scantailor-advanced"
  
  url "https://github.com/ScanTailor-Advanced/scantailor-advanced/archive/refs/tags/v1.0.19.tar.gz"
  sha256 "db41c3a1ba0ecfc00a40a4efe2bcc9d2abb71ecb77fdc873ae6553b07a228370"
  version "1.0.19"

  head "https://github.com/ScanTailor-Advanced/scantailor-advanced.git"
  
  depends_on "boost"
  depends_on "qt6"
  depends_on "libtiff" 
  depends_on "libpng" 
  depends_on "jpeg" 
  depends_on "zlib"
  depends_on "cmake" => :build
  
  def install
    vtag="#release@#{version} (build #{Time.now.utc.strftime("%Y%m%d")})"
    if build.head?
      vtag = "#master@#{version} (build #{Time.now.utc.strftime("%Y%m%d")})"
    end
    if File.file?("version.h.in")
      ohai "Setting versioning tag to #{vtag}"
      inreplace "version.h.in", /#define VERSION "([^"]*)"/, "#define VERSION \"\\1#{vtag}\""
    elsif File.file?("version.h") 
      ohai "Setting versioning tag to #{vtag}"
      inreplace "version.h", /#define VERSION "([^"]*)"/, "#define VERSION \"\\1#{vtag}\""
    end
    
    inreplace "src/foundation/Proximity.h", "#include <limits>", "#include <limits>\n#include <algorithm>"
    inreplace "src/core/Utils.h", "#include <QString>", "#include <QString>\n#include <QObject>"
    
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "install"
    end
  end
end
