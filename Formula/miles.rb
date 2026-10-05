class Miles < Formula
  desc "Port of GNOME Files (Nautilus) to macOS"
  homepage "https://github.com/astraldev/Miles"
  url "https://github.com/astraldev/Miles.git",
      tag:      "51.0.1-mac.3",
      revision: "adb4ff730f4ebd2a09953a7499293b3f23394ca5"
  version "51.0.1-mac.3"
  license "GPL-3.0-or-later"
  head "https://github.com/astraldev/Miles.git", branch: "mac-development"

  depends_on "gettext" => :build
  depends_on "librsvg" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "pygobject3" => :build
  depends_on "adwaita-icon-theme"
  depends_on arch: :arm64
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "glib-networking"
  depends_on "gnome-autoar"
  depends_on "gsettings-desktop-schemas"
  depends_on "gtk4"
  depends_on "hicolor-icon-theme"
  depends_on "icu4c@78"
  depends_on "iso-codes"
  depends_on "libadwaita"
  depends_on "libarchive"
  depends_on "libgcrypt"
  depends_on "libsoup"
  depends_on :macos
  depends_on "tinysparql"
  depends_on "xkeyboard-config"

  uses_from_macos "expat"
  uses_from_macos "libxml2"

  def install
    # The build asks brew where shared data is, and needs the Python that has PyGObject.
    ENV.prepend_path "PATH", HOMEBREW_PREFIX/"bin"

    # In libexec: Miles brings its own dbus and gvfs, which must not be linked over Homebrew's.
    args = %W[
      --prefix=#{libexec}
      --buildtype=release
      -Dextensions=false
      -Dintrospection=false
      -Ddocs=false
      -Dselinux=disabled
      -Dcloudproviders=disabled
      -Dtests=none
    ]

    # The build fetches its pinned sources itself: gvfs, dbus, libportal, gnome-desktop,
    # libgxdp, blueprint-compiler and the Yaru icons.
    system "meson", "setup", "build", *args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"

    bin.install_symlink libexec/"bin/nautilus" => "miles"
    prefix.install_symlink libexec/"Applications/Miles.app"
  end

  def post_install
    # Pouring a bottle changes files in the app, which breaks its signature.
    system "/usr/bin/codesign", "--force", "--sign", "-", libexec/"Applications/Miles.app"
  end

  def caveats
    <<~EOS
      Open Miles with:
        open #{opt_prefix}/Miles.app
      or run "miles". Keep it in the Dock to find it again.
    EOS
  end

  test do
    assert_match "nautilus 51", shell_output("#{bin}/miles --version")
  end
end
