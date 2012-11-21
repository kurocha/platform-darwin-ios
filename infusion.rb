
#
#  This file is part of the "Teapot" project, and is released under the MIT license.
#

required_version "0.2"

define_platform "darwin-ios" do |platform|
	platform.configure do
		default xcode_path Pathname.new(`xcode-select --print-path`.chomp)
		default platform_path {xcode_path + "Platforms/iPhoneOS.platform"}
		default toolchain_path {xcode_path + "Toolchains/XcodeDefault.xctoolchain"}
		
		default sdk_version {ENV["IPHONE_SDK_VERSION"] || "6.0"}
		default sdk_path {platform_path + "Developer/SDKs/iPhoneOS#{sdk_version}.sdk"}

		default architectures %W{-arch armv7}

		buildflags [
			:architectures,
			"-isysroot", :sdk_path,
			->{"-miphoneos-version-min=#{sdk_version}"},
		]

		linkflags []

		cflags [:buildflags]
		cxxflags [:buildflags]
		ldflags [:buildflags, :linkflags]

		configure ["--host=arm-apple-darwin"]

		default cc {toolchain_path + "usr/bin/clang"}
		default cxx {toolchain_path + "usr/bin/clang++"}
		default ld {toolchain_path + "usr/bin/ld"}
		default ar {toolchain_path + "usr/bin/ar"}
		default libtool {toolchain_path + "usr/bin/libtool"}
	end
	
	platform.make_available! if RUBY_PLATFORM.include?("darwin")
end
