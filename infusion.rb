
#
#  This file is part of the "Teapot" project, and is released under the MIT license.
#

required_version "0.1"

define_platform "darwin-ios" do |platform|
	platform.configure do
		xcode_path Pathname.new(`xcode-select --print-path`.chomp)
		platform_path {xcode_path + "Platforms/iPhoneOS.platform"}
		toolchain_path {xcode_path + "Toolchains/XcodeDefault.xctoolchain"}
		
		default sdk_version {ENV["IPHONE_SDK_VERSION"] || "6.0"}
		sdk_path {platform_path + "Developer/SDKs/iPhoneOS#{sdk_version}.sdk"}

		default architectures ["-arch armv7"]

		buildflags {[
			architectures,
			"-isysroot", sdk_path,
			"-miphoneos-version-min=#{sdk_version}",
		]}

		cflags {[
			buildflags
		]}

		cxxflags {[
			buildflags
		]}

		configure ["--host=arm-apple-darwin"]

		cc {toolchain_path + "usr/bin/clang"}
		cxx {toolchain_path + "usr/bin/clang++"}
		ld {toolchain_path + "usr/bin/ld"}
	end
	
	platform.make_available! if RUBY_PLATFORM.include?("darwin")
end
