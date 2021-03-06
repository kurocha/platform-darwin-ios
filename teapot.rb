
#
#  This file is part of the "Teapot" project, and is released under the MIT license.
#

teapot_version "1.0.0"

# Both iOS and the simulator provide the same targets.
def setup_provisions(target)
	target.provides 'Library/OpenGLES' do
		ldflags ["-framework", "OpenGLES"]
	end
	
	target.provides 'Library/OpenGL' => "Library/OpenGLES"
	
	target.provides 'Library/OpenAL' do
		ldflags ["-framework", "OpenAL"]
	end
	
	target.provides "Library/z" do
		append linkflags "-lz"
	end
	
	target.provides "Library/bz2" do
		append linkflags "-lbz2"
	end
	
	target.provides 'Aggregate/Display' do
		ldflags [
			"-framework", "Foundation",
			"-framework", "CoreVideo",
			"-framework", "CoreServices",
			"-framework", "UIKit"
		]
	end
end

define_target "platform-darwin-ios" do |target|
	target.provides "Platform/darwin-ios" do
		default platform_name "darwin-ios"

		default xcode_path Path.new(`xcode-select --print-path`.chomp)
		default platform_path {xcode_path + "Platforms/iPhoneOS.platform"}
		default toolchain_path {xcode_path + "Toolchains/XcodeDefault.xctoolchain"}

		default sdk_path {platform_path + "Developer/SDKs/iPhoneOS.sdk"}

		default architectures %W{-arch armv7}

		buildflags [
			:architectures,
			"-isysroot", :sdk_path,
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
	
	target.depends :variant
	
	target.provides :platform => ["Platform/darwin-ios"]
	
	setup_provisions(target)
end

define_target "platform-darwin-ios-simulator" do |target|
	target.provides "Platform/darwin-ios-simulator" do
		default platform_name "darwin-ios-simulator"

		default xcode_path Path.new(`xcode-select --print-path`.chomp)
		default platform_path {xcode_path + "Platforms/iPhoneSimulator.platform"}
		default toolchain_path {xcode_path + "Toolchains/XcodeDefault.xctoolchain"}
		
		default sdk_path {platform_path + "Developer/SDKs/iPhoneSimulator.sdk"}

		default architectures %W{-arch i386}

		buildflags [
			:architectures,
			"-isysroot", :sdk_path,
			"-pipe"
		]

		linkflags []

		cflags [:buildflags]
		cxxflags [:buildflags]
		ldflags [:buildflags, :linkflags]

		configure []

		default cc {toolchain_path + "usr/bin/clang"}
		default cxx {toolchain_path + "usr/bin/clang++"}
		default ld {toolchain_path + "usr/bin/ld"}
		default ar {toolchain_path + "usr/bin/ar"}
		default libtool {toolchain_path + "usr/bin/libtool"}
	end
	
	target.depends :variant
	
	target.provides :platform => ["Platform/darwin-ios-simulator"]
	
	setup_provisions(target)
end
