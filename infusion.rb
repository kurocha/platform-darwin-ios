
#
#  This file is part of the "Teapot" project, and is released under the MIT license.
#

required_version "0.5"

define_package "darwin-ios" do |package|
	package.provides "System/darwin-ios" do
		default platform_name "darwin-ios"

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
			"-pipe"
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
	
	package.provides :system => ["System/darwin-ios"]
	
	package.provides 'Language/C++11' do
		cxxflags %W{-std=c++11 -stdlib=libc++ -Wno-c++11-narrowing}
	end
	
	package.provides 'Library/OpenGLES' do
		ldflags ["-framework", "OpenGLES"]
	end
	
	package.provides 'Aggregate/OpenGL' => "Library/OpenGLES"
	
	package.provides 'Library/OpenAL' do
		ldflags ["-framework", "OpenAL"]
	end
	
	package.provides 'Aggregate/UIKit' do
		ldflags [
			"-framework", "Foundation",
			"-framework", "CoreVideo",
			"-framework", "CoreServices",
			"-framework", "UIKit"
		]
	end
end
