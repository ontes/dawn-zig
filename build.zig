const std = @import("std");

pub const DawnOptions = struct {
    enable_d3d12: bool,
    enable_metal: bool,
    enable_null: bool,
    enable_opengl: bool,
    enable_opengles: bool,
    enable_vulkan: bool,
    use_wayland: bool,
    use_x11: bool,

    pub fn standard(b: *std.build.Builder, os_tag: std.Target.Os.Tag) DawnOptions {
        return .{
            .enable_d3d12 = b.option(bool, "enable-d3d12", "enable DirectX 12 backend") orelse (os_tag == .windows),
            .enable_metal = b.option(bool, "enable-metal", "enable Metal backend") orelse (os_tag == .macos),
            .enable_null = b.option(bool, "enable-null", "enable Null backend") orelse true,
            .enable_opengl = b.option(bool, "enable-opengl", "enable OpenGL backend") orelse (os_tag == .linux),
            .enable_opengles = b.option(bool, "enable-opengles", "enable OpenGL ES backend") orelse (os_tag == .linux),
            .enable_vulkan = b.option(bool, "enable-vulkan", "enable Vulkan backend") orelse (os_tag == .windows or os_tag == .linux),
            .use_wayland = b.option(bool, "use-wayland", "use Wayland") orelse false,
            .use_x11 = b.option(bool, "use-x11", "use X11") orelse (os_tag == .linux),
        };
    }
};

pub fn link(step: *std.build.LibExeObjStep, options: DawnOptions, comptime path: []const u8) void {
    const os_tag = step.target.os_tag orelse @import("builtin").target.os.tag;
    const c_flags = &[_][]const u8{ "-std=c++17", "-g0", "-fvisibility=hidden" };

    step.linkLibCpp();

    if (os_tag == .windows) {
        step.addIncludePath(path ++ "windows-sdk/include");
        step.defineCMacro("_Maybenull_", ""); // fix for dxcapi.h
    }

    { // dawn
        step.addIncludePath(path ++ "dawn/include");
        step.addIncludePath(path ++ "dawn-gen/include");

        step.addIncludePath(path ++ "dawn/src");
        step.addIncludePath(path ++ "dawn-gen/src");

        if (step.build_mode == .Debug)
            step.defineCMacro("DAWN_ENABLE_ASSERTS", null);
        if (options.enable_d3d12)
            step.defineCMacro("DAWN_ENABLE_BACKEND_D3D12", null);
        if (options.enable_metal)
            step.defineCMacro("DAWN_ENABLE_BACKEND_METAL", null);
        if (options.enable_null)
            step.defineCMacro("DAWN_ENABLE_BACKEND_NULL", null);
        if (options.enable_opengl)
            step.defineCMacro("DAWN_ENABLE_BACKEND_DESKTOP_GL", null);
        if (options.enable_opengles)
            step.defineCMacro("DAWN_ENABLE_BACKEND_OPENGLES", null);
        if (options.enable_opengl or options.enable_opengles)
            step.defineCMacro("DAWN_ENABLE_BACKEND_OPENGL", null);
        if (options.enable_vulkan)
            step.defineCMacro("DAWN_ENABLE_BACKEND_VULKAN", null);
        if (options.use_wayland)
            step.defineCMacro("DAWN_USE_WAYLAND", null);
        if (options.use_x11)
            step.defineCMacro("DAWN_USE_X11", null);
        if (os_tag == .windows) {
            step.defineCMacro("NOMINMAX", null);
            step.defineCMacro("WIN32_LEAN_AND_MEAN", null);
        }

        const src_path = path ++ "dawn/src/dawn/";
        const gen_src_path = path ++ "dawn-gen/src/dawn/";

        step.addCSourceFiles(&.{
            src_path ++ "common/Assert.cpp",
            src_path ++ "common/DynamicLib.cpp",
            src_path ++ "common/GPUInfo.cpp",
            src_path ++ "common/Log.cpp",
            src_path ++ "common/Math.cpp",
            src_path ++ "common/RefCounted.cpp",
            src_path ++ "common/Result.cpp",
            src_path ++ "common/SlabAllocator.cpp",
            src_path ++ "common/SystemUtils.cpp",
            gen_src_path ++ "common/GPUInfo_autogen.cpp",
        }, c_flags);
        if (os_tag == .windows)
            step.addCSourceFile(src_path ++ "common/WindowsUtils.cpp", c_flags);
        if (os_tag == .macos)
            step.addCSourceFile(src_path ++ "common/SystemUtils_mac.mm", c_flags);

        step.addCSourceFiles(&.{
            src_path ++ "platform/DawnPlatform.cpp",
            src_path ++ "platform/WorkerThread.cpp",
            src_path ++ "platform/tracing/EventTracer.cpp",
        }, c_flags);

        step.addCSourceFiles(&.{
            src_path ++ "native/DawnNative.cpp",
            src_path ++ "native/Adapter.cpp",
            src_path ++ "native/ApplyClearColorValueWithDrawHelper.cpp",
            src_path ++ "native/AsyncTask.cpp",
            src_path ++ "native/AttachmentState.cpp",
            src_path ++ "native/BackendConnection.cpp",
            src_path ++ "native/BindGroup.cpp",
            src_path ++ "native/BindGroupLayout.cpp",
            src_path ++ "native/BindingInfo.cpp",
            src_path ++ "native/Blob.cpp",
            src_path ++ "native/BlobCache.cpp",
            src_path ++ "native/BuddyAllocator.cpp",
            src_path ++ "native/BuddyMemoryAllocator.cpp",
            src_path ++ "native/Buffer.cpp",
            src_path ++ "native/CachedObject.cpp",
            src_path ++ "native/CacheKey.cpp",
            src_path ++ "native/CacheRequest.cpp",
            src_path ++ "native/CallbackTaskManager.cpp",
            src_path ++ "native/CommandAllocator.cpp",
            src_path ++ "native/CommandBuffer.cpp",
            src_path ++ "native/CommandBufferStateTracker.cpp",
            src_path ++ "native/CommandEncoder.cpp",
            src_path ++ "native/CommandValidation.cpp",
            src_path ++ "native/Commands.cpp",
            src_path ++ "native/CompilationMessages.cpp",
            src_path ++ "native/ComputePassEncoder.cpp",
            src_path ++ "native/ComputePipeline.cpp",
            src_path ++ "native/CopyTextureForBrowserHelper.cpp",
            src_path ++ "native/CreatePipelineAsyncTask.cpp",
            src_path ++ "native/Device.cpp",
            src_path ++ "native/DynamicUploader.cpp",
            src_path ++ "native/EncodingContext.cpp",
            src_path ++ "native/Error.cpp",
            src_path ++ "native/ErrorData.cpp",
            src_path ++ "native/ErrorInjector.cpp",
            src_path ++ "native/ErrorScope.cpp",
            src_path ++ "native/Features.cpp",
            src_path ++ "native/ExternalTexture.cpp",
            src_path ++ "native/IndirectDrawMetadata.cpp",
            src_path ++ "native/IndirectDrawValidationEncoder.cpp",
            src_path ++ "native/ObjectContentHasher.cpp",
            src_path ++ "native/Format.cpp",
            src_path ++ "native/Instance.cpp",
            src_path ++ "native/InternalPipelineStore.cpp",
            src_path ++ "native/Limits.cpp",
            src_path ++ "native/ObjectBase.cpp",
            src_path ++ "native/PassResourceUsage.cpp",
            src_path ++ "native/PassResourceUsageTracker.cpp",
            src_path ++ "native/PerStage.cpp",
            src_path ++ "native/Pipeline.cpp",
            src_path ++ "native/PipelineCache.cpp",
            src_path ++ "native/PipelineLayout.cpp",
            src_path ++ "native/PooledResourceMemoryAllocator.cpp",
            src_path ++ "native/ProgrammableEncoder.cpp",
            src_path ++ "native/QueryHelper.cpp",
            src_path ++ "native/QuerySet.cpp",
            src_path ++ "native/Queue.cpp",
            src_path ++ "native/RefCountedWithExternalCount.cpp",
            src_path ++ "native/RenderBundle.cpp",
            src_path ++ "native/RenderBundleEncoder.cpp",
            src_path ++ "native/RenderEncoderBase.cpp",
            src_path ++ "native/RenderPassEncoder.cpp",
            src_path ++ "native/RenderPipeline.cpp",
            src_path ++ "native/ResourceMemoryAllocation.cpp",
            src_path ++ "native/RingBufferAllocator.cpp",
            src_path ++ "native/Sampler.cpp",
            src_path ++ "native/ScratchBuffer.cpp",
            src_path ++ "native/ShaderModule.cpp",
            src_path ++ "native/StagingBuffer.cpp",
            src_path ++ "native/StreamImplTint.cpp",
            src_path ++ "native/Subresource.cpp",
            // src_path ++ "native/Surface.cpp",
            path ++ "Surface.cpp", // fixed Windows compatibility
            src_path ++ "native/SwapChain.cpp",
            src_path ++ "native/Texture.cpp",
            src_path ++ "native/TintUtils.cpp",
            src_path ++ "native/Toggles.cpp",
            src_path ++ "native/VertexFormat.cpp",
            src_path ++ "native/webgpu_absl_format.cpp",
            src_path ++ "native/stream/BlobSource.cpp",
            src_path ++ "native/stream/ByteVectorSink.cpp",
            src_path ++ "native/stream/Stream.cpp",
            src_path ++ "native/utils/WGPUHelpers.cpp",
            gen_src_path ++ "native/ChainUtils_autogen.cpp",
            gen_src_path ++ "native/ObjectType_autogen.cpp",
            gen_src_path ++ "native/ProcTable.cpp",
            gen_src_path ++ "native/ValidationUtils_autogen.cpp",
            gen_src_path ++ "native/webgpu_absl_format_autogen.cpp",
            gen_src_path ++ "native/webgpu_StreamImpl_autogen.cpp",
            gen_src_path ++ "native/wgpu_structs_autogen.cpp",
        }, c_flags);
        if (options.use_x11) {
            step.linkSystemLibrary("X11");
            step.addCSourceFile(src_path ++ "native/XlibXcbFunctions.cpp", c_flags);
        }
        if (os_tag == .windows) {
            step.linkSystemLibrary("user32");
        }
        if (options.enable_d3d12) {
            step.addCSourceFiles(&.{
                src_path ++ "native/d3d12/D3D12Backend.cpp",
                src_path ++ "native/d3d12/AdapterD3D12.cpp",
                src_path ++ "native/d3d12/BackendD3D12.cpp",
                src_path ++ "native/d3d12/BindGroupD3D12.cpp",
                src_path ++ "native/d3d12/BindGroupLayoutD3D12.cpp",
                src_path ++ "native/d3d12/BlobD3D12.cpp",
                src_path ++ "native/d3d12/BufferD3D12.cpp",
                src_path ++ "native/d3d12/CPUDescriptorHeapAllocationD3D12.cpp",
                src_path ++ "native/d3d12/CommandAllocatorManager.cpp",
                src_path ++ "native/d3d12/CommandBufferD3D12.cpp",
                src_path ++ "native/d3d12/CommandRecordingContext.cpp",
                src_path ++ "native/d3d12/ComputePipelineD3D12.cpp",
                src_path ++ "native/d3d12/D3D11on12Util.cpp",
                src_path ++ "native/d3d12/D3D12Error.cpp",
                src_path ++ "native/d3d12/D3D12Info.cpp",
                src_path ++ "native/d3d12/DeviceD3D12.cpp",
                src_path ++ "native/d3d12/ExternalImageDXGIImpl.cpp",
                src_path ++ "native/d3d12/FenceD3D12.cpp",
                src_path ++ "native/d3d12/GPUDescriptorHeapAllocationD3D12.cpp",
                src_path ++ "native/d3d12/HeapAllocatorD3D12.cpp",
                src_path ++ "native/d3d12/HeapD3D12.cpp",
                src_path ++ "native/d3d12/NativeSwapChainImplD3D12.cpp",
                src_path ++ "native/d3d12/PageableD3D12.cpp",
                src_path ++ "native/d3d12/PipelineLayoutD3D12.cpp",
                src_path ++ "native/d3d12/PlatformFunctions.cpp",
                src_path ++ "native/d3d12/QuerySetD3D12.cpp",
                src_path ++ "native/d3d12/QueueD3D12.cpp",
                src_path ++ "native/d3d12/RenderPassBuilderD3D12.cpp",
                src_path ++ "native/d3d12/RenderPipelineD3D12.cpp",
                src_path ++ "native/d3d12/ResidencyManagerD3D12.cpp",
                src_path ++ "native/d3d12/ResourceAllocatorManagerD3D12.cpp",
                src_path ++ "native/d3d12/ResourceHeapAllocationD3D12.cpp",
                src_path ++ "native/d3d12/SamplerD3D12.cpp",
                src_path ++ "native/d3d12/SamplerHeapCacheD3D12.cpp",
                src_path ++ "native/d3d12/ShaderModuleD3D12.cpp",
                src_path ++ "native/d3d12/ShaderVisibleDescriptorAllocatorD3D12.cpp",
                src_path ++ "native/d3d12/StagingBufferD3D12.cpp",
                src_path ++ "native/d3d12/StagingDescriptorAllocatorD3D12.cpp",
                src_path ++ "native/d3d12/StreamImplD3D12.cpp",
                src_path ++ "native/d3d12/SwapChainD3D12.cpp",
                src_path ++ "native/d3d12/TextureCopySplitter.cpp",
                src_path ++ "native/d3d12/TextureD3D12.cpp",
                src_path ++ "native/d3d12/UtilsD3D12.cpp",
            }, c_flags);
            step.linkSystemLibrary("dxguid");
        }
        if (options.enable_metal) {
            step.addCSourceFiles(&.{
                src_path ++ "native/metal/MetalBackend.mm",
                src_path ++ "native/Surface_metal.mm",
                src_path ++ "native/metal/BackendMTL.mm",
                src_path ++ "native/metal/BindGroupLayoutMTL.mm",
                src_path ++ "native/metal/BindGroupMTL.mm",
                src_path ++ "native/metal/BufferMTL.mm",
                src_path ++ "native/metal/CommandBufferMTL.mm",
                src_path ++ "native/metal/CommandRecordingContext.mm",
                src_path ++ "native/metal/ComputePipelineMTL.mm",
                src_path ++ "native/metal/DeviceMTL.mm",
                src_path ++ "native/metal/PipelineLayoutMTL.mm",
                src_path ++ "native/metal/QueueMTL.mm",
                src_path ++ "native/metal/QuerySetMTL.mm",
                src_path ++ "native/metal/RenderPipelineMTL.mm",
                src_path ++ "native/metal/SamplerMTL.mm",
                src_path ++ "native/metal/ShaderModuleMTL.mm",
                src_path ++ "native/metal/StagingBufferMTL.mm",
                src_path ++ "native/metal/SwapChainMTL.mm",
                src_path ++ "native/metal/TextureMTL.mm",
                src_path ++ "native/metal/UtilsMetal.mm",
            }, c_flags);
            step.linkFramework("Cocoa");
            step.linkFramework("IOKit");
            step.linkFramework("IOSurface");
            step.linkFramework("QuartzCore");
            step.linkFramework("Metal");
        }
        if (options.enable_null) {
            step.addCSourceFiles(&.{
                src_path ++ "native/null/NullBackend.cpp",
                src_path ++ "native/null/DeviceNull.cpp",
            }, c_flags);
        }
        if (options.enable_opengl or options.enable_opengles or options.enable_vulkan)
            step.addCSourceFile(src_path ++ "native/SpirvValidation.cpp", c_flags);
        if (options.enable_opengl or options.enable_opengles) {
            step.addCSourceFiles(&.{
                src_path ++ "native/opengl/OpenGLBackend.cpp",
                src_path ++ "native/opengl/AdapterGL.cpp",
                src_path ++ "native/opengl/BackendGL.cpp",
                src_path ++ "native/opengl/BindGroupGL.cpp",
                src_path ++ "native/opengl/BindGroupLayoutGL.cpp",
                src_path ++ "native/opengl/BufferGL.cpp",
                src_path ++ "native/opengl/CommandBufferGL.cpp",
                src_path ++ "native/opengl/ComputePipelineGL.cpp",
                src_path ++ "native/opengl/ContextEGL.cpp",
                src_path ++ "native/opengl/DeviceGL.cpp",
                src_path ++ "native/opengl/EGLFunctions.cpp",
                src_path ++ "native/opengl/GLFormat.cpp",
                src_path ++ "native/opengl/NativeSwapChainImplGL.cpp",
                src_path ++ "native/opengl/OpenGLFunctions.cpp",
                src_path ++ "native/opengl/OpenGLVersion.cpp",
                src_path ++ "native/opengl/PersistentPipelineStateGL.cpp",
                src_path ++ "native/opengl/PipelineGL.cpp",
                src_path ++ "native/opengl/PipelineLayoutGL.cpp",
                src_path ++ "native/opengl/QuerySetGL.cpp",
                src_path ++ "native/opengl/QueueGL.cpp",
                src_path ++ "native/opengl/RenderPipelineGL.cpp",
                src_path ++ "native/opengl/SamplerGL.cpp",
                src_path ++ "native/opengl/ShaderModuleGL.cpp",
                src_path ++ "native/opengl/SwapChainGL.cpp",
                src_path ++ "native/opengl/TextureGL.cpp",
                src_path ++ "native/opengl/UtilsEGL.cpp",
                src_path ++ "native/opengl/UtilsGL.cpp",
                gen_src_path ++ "native/opengl/OpenGLFunctionsBase_autogen.cpp",
            }, c_flags);
            step.addIncludePath(path ++ "dawn/third_party/khronos");
        }
        if (options.enable_vulkan) {
            step.addCSourceFiles(&.{
                src_path ++ "native/vulkan/VulkanBackend.cpp",
                src_path ++ "native/vulkan/AdapterVk.cpp",
                src_path ++ "native/vulkan/BackendVk.cpp",
                src_path ++ "native/vulkan/BindGroupLayoutVk.cpp",
                src_path ++ "native/vulkan/BindGroupVk.cpp",
                src_path ++ "native/vulkan/BufferVk.cpp",
                src_path ++ "native/vulkan/CommandBufferVk.cpp",
                src_path ++ "native/vulkan/ComputePipelineVk.cpp",
                src_path ++ "native/vulkan/DescriptorSetAllocator.cpp",
                src_path ++ "native/vulkan/DeviceVk.cpp",
                src_path ++ "native/vulkan/FencedDeleter.cpp",
                src_path ++ "native/vulkan/NativeSwapChainImplVk.cpp",
                src_path ++ "native/vulkan/PipelineCacheVk.cpp",
                src_path ++ "native/vulkan/PipelineLayoutVk.cpp",
                src_path ++ "native/vulkan/QuerySetVk.cpp",
                src_path ++ "native/vulkan/QueueVk.cpp",
                src_path ++ "native/vulkan/RenderPassCache.cpp",
                src_path ++ "native/vulkan/RenderPipelineVk.cpp",
                src_path ++ "native/vulkan/ResourceHeapVk.cpp",
                src_path ++ "native/vulkan/ResourceMemoryAllocatorVk.cpp",
                src_path ++ "native/vulkan/SamplerVk.cpp",
                src_path ++ "native/vulkan/ShaderModuleVk.cpp",
                src_path ++ "native/vulkan/StagingBufferVk.cpp",
                src_path ++ "native/vulkan/StreamImplVk.cpp",
                src_path ++ "native/vulkan/SwapChainVk.cpp",
                src_path ++ "native/vulkan/TextureVk.cpp",
                src_path ++ "native/vulkan/UtilsVulkan.cpp",
                src_path ++ "native/vulkan/VulkanError.cpp",
                src_path ++ "native/vulkan/VulkanExtensions.cpp",
                src_path ++ "native/vulkan/VulkanFunctions.cpp",
                src_path ++ "native/vulkan/VulkanInfo.cpp",
                src_path ++ "native/vulkan/external_memory/MemoryService.cpp",
            }, c_flags);
            if (os_tag == .linux) {
                step.addCSourceFiles(&.{
                    src_path ++ "native/vulkan/external_memory/MemoryServiceOpaqueFD.cpp",
                    src_path ++ "native/vulkan/external_semaphore/SemaphoreServiceFD.cpp",
                }, c_flags);
            } else {
                step.addCSourceFiles(&.{
                    src_path ++ "native/vulkan/external_memory/MemoryServiceNull.cpp",
                    src_path ++ "native/vulkan/external_semaphore/SemaphoreServiceNull.cpp",
                }, c_flags);
            }
            step.addIncludePath(path ++ "vulkan-headers/include");
            step.addIncludePath(path ++ "vulkan-tools");
        }

        step.addCSourceFile(gen_src_path ++ "native/webgpu_dawn_native_proc.cpp", c_flags);
    }

    { // tint
        step.addIncludePath(path ++ "dawn");
        step.addIncludePath(path ++ "dawn/include");

        step.defineCMacro("TINT_BUILD_WGSL_READER", null);
        step.defineCMacro("TINT_BUILD_WGSL_WRITER", null);
        if (options.enable_vulkan) {
            step.defineCMacro("TINT_BUILD_SPV_READER", null);
            step.defineCMacro("TINT_BUILD_SPV_WRITER", null);
        }
        if (options.enable_opengl or options.enable_opengles)
            step.defineCMacro("TINT_BUILD_GLSL_WRITER", null);
        if (options.enable_d3d12)
            step.defineCMacro("TINT_BUILD_HLSL_WRITER", null);
        if (options.enable_metal)
            step.defineCMacro("TINT_BUILD_MSL_WRITER", null);

        const src_path = path ++ "dawn/src/tint/";

        step.addCSourceFiles(&.{
            src_path ++ "debug.cc",
            src_path ++ "source.cc",
            src_path ++ "diagnostic/diagnostic.cc",
            src_path ++ "diagnostic/formatter.cc",
            src_path ++ "diagnostic/printer.cc",
            src_path ++ "utils/debugger.cc",
        }, c_flags);
        step.addCSourceFiles(&.{
            src_path ++ "ast/alias.cc",
            src_path ++ "ast/array.cc",
            src_path ++ "ast/assignment_statement.cc",
            src_path ++ "ast/ast_type.cc",
            src_path ++ "ast/atomic.cc",
            src_path ++ "ast/attribute.cc",
            src_path ++ "ast/binary_expression.cc",
            src_path ++ "ast/binding_attribute.cc",
            src_path ++ "ast/bitcast_expression.cc",
            src_path ++ "ast/block_statement.cc",
            src_path ++ "ast/bool_literal_expression.cc",
            src_path ++ "ast/bool.cc",
            src_path ++ "ast/break_if_statement.cc",
            src_path ++ "ast/break_statement.cc",
            src_path ++ "ast/builtin_attribute.cc",
            src_path ++ "ast/call_expression.cc",
            src_path ++ "ast/call_statement.cc",
            src_path ++ "ast/case_selector.cc",
            src_path ++ "ast/case_statement.cc",
            src_path ++ "ast/compound_assignment_statement.cc",
            src_path ++ "ast/const.cc",
            src_path ++ "ast/continue_statement.cc",
            src_path ++ "ast/depth_multisampled_texture.cc",
            src_path ++ "ast/depth_texture.cc",
            src_path ++ "ast/disable_validation_attribute.cc",
            src_path ++ "ast/discard_statement.cc",
            src_path ++ "ast/enable.cc",
            src_path ++ "ast/expression.cc",
            src_path ++ "ast/external_texture.cc",
            src_path ++ "ast/f16.cc",
            src_path ++ "ast/f32.cc",
            src_path ++ "ast/float_literal_expression.cc",
            src_path ++ "ast/for_loop_statement.cc",
            src_path ++ "ast/function.cc",
            src_path ++ "ast/group_attribute.cc",
            src_path ++ "ast/i32.cc",
            src_path ++ "ast/id_attribute.cc",
            src_path ++ "ast/identifier_expression.cc",
            src_path ++ "ast/if_statement.cc",
            src_path ++ "ast/increment_decrement_statement.cc",
            src_path ++ "ast/index_accessor_expression.cc",
            src_path ++ "ast/int_literal_expression.cc",
            src_path ++ "ast/internal_attribute.cc",
            src_path ++ "ast/invariant_attribute.cc",
            src_path ++ "ast/let.cc",
            src_path ++ "ast/literal_expression.cc",
            src_path ++ "ast/location_attribute.cc",
            src_path ++ "ast/loop_statement.cc",
            src_path ++ "ast/matrix.cc",
            src_path ++ "ast/member_accessor_expression.cc",
            src_path ++ "ast/module.cc",
            src_path ++ "ast/multisampled_texture.cc",
            src_path ++ "ast/node.cc",
            src_path ++ "ast/override.cc",
            src_path ++ "ast/parameter.cc",
            src_path ++ "ast/phony_expression.cc",
            src_path ++ "ast/pipeline_stage.cc",
            src_path ++ "ast/pointer.cc",
            src_path ++ "ast/return_statement.cc",
            src_path ++ "ast/sampled_texture.cc",
            src_path ++ "ast/sampler.cc",
            src_path ++ "ast/stage_attribute.cc",
            src_path ++ "ast/statement.cc",
            src_path ++ "ast/static_assert.cc",
            src_path ++ "ast/storage_texture.cc",
            src_path ++ "ast/stride_attribute.cc",
            src_path ++ "ast/struct_member_align_attribute.cc",
            src_path ++ "ast/struct_member_offset_attribute.cc",
            src_path ++ "ast/struct_member_size_attribute.cc",
            src_path ++ "ast/struct_member.cc",
            src_path ++ "ast/struct.cc",
            src_path ++ "ast/switch_statement.cc",
            src_path ++ "ast/texture.cc",
            src_path ++ "ast/type_decl.cc",
            src_path ++ "ast/type_name.cc",
            src_path ++ "ast/u32.cc",
            src_path ++ "ast/unary_op_expression.cc",
            src_path ++ "ast/unary_op.cc",
            src_path ++ "ast/var.cc",
            src_path ++ "ast/variable_decl_statement.cc",
            src_path ++ "ast/variable.cc",
            src_path ++ "ast/vector.cc",
            src_path ++ "ast/void.cc",
            src_path ++ "ast/while_statement.cc",
            src_path ++ "ast/workgroup_attribute.cc",
            src_path ++ "castable.cc",
            src_path ++ "clone_context.cc",
            src_path ++ "constant/composite.cc",
            src_path ++ "constant/scalar.cc",
            src_path ++ "constant/splat.cc",
            src_path ++ "constant/node.cc",
            src_path ++ "constant/value.cc",
            src_path ++ "demangler.cc",
            src_path ++ "inspector/entry_point.cc",
            src_path ++ "inspector/inspector.cc",
            src_path ++ "inspector/resource_binding.cc",
            src_path ++ "inspector/scalar.cc",
            src_path ++ "number.cc",
            src_path ++ "program_builder.cc",
            src_path ++ "program_id.cc",
            src_path ++ "program.cc",
            src_path ++ "reader/reader.cc",
            src_path ++ "resolver/const_eval.cc",
            src_path ++ "resolver/dependency_graph.cc",
            src_path ++ "resolver/intrinsic_table.cc",
            src_path ++ "resolver/resolver.cc",
            src_path ++ "resolver/sem_helper.cc",
            src_path ++ "resolver/uniformity.cc",
            src_path ++ "resolver/validator.cc",
            src_path ++ "sem/array_count.cc",
            src_path ++ "sem/behavior.cc",
            src_path ++ "sem/block_statement.cc",
            src_path ++ "sem/break_if_statement.cc",
            src_path ++ "sem/builtin.cc",
            src_path ++ "sem/call_target.cc",
            src_path ++ "sem/call.cc",
            src_path ++ "sem/expression.cc",
            src_path ++ "sem/for_loop_statement.cc",
            src_path ++ "sem/function.cc",
            src_path ++ "sem/if_statement.cc",
            src_path ++ "sem/index_accessor_expression.cc",
            src_path ++ "sem/info.cc",
            src_path ++ "sem/load.cc",
            src_path ++ "sem/loop_statement.cc",
            src_path ++ "sem/materialize.cc",
            src_path ++ "sem/member_accessor_expression.cc",
            src_path ++ "sem/module.cc",
            src_path ++ "sem/node.cc",
            src_path ++ "sem/statement.cc",
            src_path ++ "sem/struct.cc",
            src_path ++ "sem/switch_statement.cc",
            src_path ++ "sem/type_initializer.cc",
            src_path ++ "sem/type_conversion.cc",
            src_path ++ "sem/variable.cc",
            src_path ++ "sem/while_statement.cc",
            src_path ++ "symbol_table.cc",
            src_path ++ "symbol.cc",
            src_path ++ "tint.cc",
            src_path ++ "text/unicode.cc",
            src_path ++ "transform/add_empty_entry_point.cc",
            src_path ++ "transform/add_block_attribute.cc",
            src_path ++ "transform/array_length_from_uniform.cc",
            src_path ++ "transform/binding_remapper.cc",
            src_path ++ "transform/builtin_polyfill.cc",
            src_path ++ "transform/calculate_array_length.cc",
            src_path ++ "transform/clamp_frag_depth.cc",
            src_path ++ "transform/canonicalize_entry_point_io.cc",
            src_path ++ "transform/combine_samplers.cc",
            src_path ++ "transform/decompose_memory_access.cc",
            src_path ++ "transform/decompose_strided_array.cc",
            src_path ++ "transform/decompose_strided_matrix.cc",
            src_path ++ "transform/demote_to_helper.cc",
            src_path ++ "transform/direct_variable_access.cc",
            src_path ++ "transform/disable_uniformity_analysis.cc",
            src_path ++ "transform/expand_compound_assignment.cc",
            src_path ++ "transform/first_index_offset.cc",
            src_path ++ "transform/for_loop_to_loop.cc",
            src_path ++ "transform/localize_struct_array_assignment.cc",
            src_path ++ "transform/manager.cc",
            src_path ++ "transform/merge_return.cc",
            src_path ++ "transform/module_scope_var_to_entry_point_param.cc",
            src_path ++ "transform/multiplanar_external_texture.cc",
            src_path ++ "transform/num_workgroups_from_uniform.cc",
            src_path ++ "transform/packed_vec3.cc",
            src_path ++ "transform/pad_structs.cc",
            src_path ++ "transform/preserve_padding.cc",
            src_path ++ "transform/promote_initializers_to_let.cc",
            src_path ++ "transform/promote_side_effects_to_decl.cc",
            src_path ++ "transform/remove_continue_in_switch.cc",
            src_path ++ "transform/remove_phonies.cc",
            src_path ++ "transform/remove_unreachable_statements.cc",
            src_path ++ "transform/renamer.cc",
            src_path ++ "transform/robustness.cc",
            src_path ++ "transform/simplify_pointers.cc",
            src_path ++ "transform/single_entry_point.cc",
            src_path ++ "transform/spirv_atomic.cc",
            src_path ++ "transform/std140.cc",
            src_path ++ "transform/substitute_override.cc",
            src_path ++ "transform/texture_1d_to_2d.cc",
            src_path ++ "transform/transform.cc",
            src_path ++ "transform/truncate_interstage_variables.cc",
            src_path ++ "transform/unshadow.cc",
            src_path ++ "transform/utils/get_insertion_point.cc",
            src_path ++ "transform/utils/hoist_to_decl_before.cc",
            src_path ++ "transform/var_for_dynamic_index.cc",
            src_path ++ "transform/vectorize_matrix_conversions.cc",
            src_path ++ "transform/vectorize_scalar_matrix_initializers.cc",
            src_path ++ "transform/vertex_pulling.cc",
            src_path ++ "transform/while_to_loop.cc",
            src_path ++ "transform/zero_init_workgroup_memory.cc",
            src_path ++ "type/abstract_float.cc",
            src_path ++ "type/abstract_int.cc",
            src_path ++ "type/abstract_numeric.cc",
            src_path ++ "type/array.cc",
            src_path ++ "type/array_count.cc",
            src_path ++ "type/atomic.cc",
            src_path ++ "type/bool.cc",
            src_path ++ "type/depth_multisampled_texture.cc",
            src_path ++ "type/depth_texture.cc",
            src_path ++ "type/external_texture.cc",
            src_path ++ "type/f16.cc",
            src_path ++ "type/f32.cc",
            src_path ++ "type/i32.cc",
            src_path ++ "type/manager.cc",
            src_path ++ "type/matrix.cc",
            src_path ++ "type/multisampled_texture.cc",
            src_path ++ "type/node.cc",
            src_path ++ "type/pointer.cc",
            src_path ++ "type/reference.cc",
            src_path ++ "type/sampled_texture.cc",
            src_path ++ "type/sampler.cc",
            src_path ++ "type/storage_texture.cc",
            src_path ++ "type/struct.cc",
            src_path ++ "type/texture.cc",
            src_path ++ "type/type.cc",
            src_path ++ "type/u32.cc",
            src_path ++ "type/unique_node.cc",
            src_path ++ "type/vector.cc",
            src_path ++ "type/void.cc",
            src_path ++ "utils/string.cc",
            src_path ++ "writer/append_vector.cc",
            src_path ++ "writer/array_length_from_uniform_options.cc",
            src_path ++ "writer/check_supported_extensions.cc",
            src_path ++ "writer/flatten_bindings.cc",
            src_path ++ "writer/float_to_string.cc",
            src_path ++ "writer/generate_external_texture_bindings.cc",
            src_path ++ "writer/text_generator.cc",
            src_path ++ "writer/text.cc",
            src_path ++ "writer/writer.cc",
        }, c_flags);
        step.addCSourceFiles(&.{
            src_path ++ "ast/access.cc",
            src_path ++ "ast/address_space.cc",
            src_path ++ "ast/builtin_value.cc",
            src_path ++ "ast/extension.cc",
            src_path ++ "ast/interpolate_attribute.cc",
            src_path ++ "ast/texel_format.cc",
            src_path ++ "resolver/init_conv_intrinsic.cc",
            src_path ++ "sem/builtin_type.cc",
            src_path ++ "sem/parameter_usage.cc",
            src_path ++ "type/short_name.cc",
        }, c_flags);
        step.addCSourceFiles(&.{
            src_path ++ "reader/wgsl/lexer.cc",
            src_path ++ "reader/wgsl/parser.cc",
            src_path ++ "reader/wgsl/parser_impl.cc",
            src_path ++ "reader/wgsl/token.cc",
        }, c_flags);
        step.addCSourceFiles(&.{
            src_path ++ "writer/wgsl/generator.cc",
            src_path ++ "writer/wgsl/generator_impl.cc",
        }, c_flags);
        if (options.enable_vulkan) {
            step.addCSourceFiles(&.{
                src_path ++ "reader/spirv/construct.cc",
                src_path ++ "reader/spirv/entry_point_info.cc",
                src_path ++ "reader/spirv/enum_converter.cc",
                src_path ++ "reader/spirv/function.cc",
                src_path ++ "reader/spirv/namer.cc",
                src_path ++ "reader/spirv/parser_type.cc",
                src_path ++ "reader/spirv/parser.cc",
                src_path ++ "reader/spirv/parser_impl.cc",
                src_path ++ "reader/spirv/usage.cc",
            }, c_flags);
            step.addCSourceFiles(&.{
                src_path ++ "writer/spirv/binary_writer.cc",
                src_path ++ "writer/spirv/builder.cc",
                src_path ++ "writer/spirv/function.cc",
                src_path ++ "writer/spirv/generator.cc",
                src_path ++ "writer/spirv/generator_impl.cc",
                src_path ++ "writer/spirv/instruction.cc",
                src_path ++ "writer/spirv/operand.cc",
            }, c_flags);
        }
        if (options.enable_metal) {
            step.addCSourceFiles(&.{
                src_path ++ "writer/msl/generator.cc",
                src_path ++ "writer/msl/generator_impl.cc",
            }, c_flags);
        }
        if (options.enable_opengl or options.enable_opengles) {
            step.addCSourceFiles(&.{
                src_path ++ "writer/glsl/generator.cc",
                src_path ++ "writer/glsl/generator_impl.cc",
            }, c_flags);
        }
        if (options.enable_d3d12) {
            step.addCSourceFiles(&.{
                src_path ++ "writer/hlsl/generator.cc",
                src_path ++ "writer/hlsl/generator_impl.cc",
            }, c_flags);
        }
    }

    { // spirv-tools, NOTE: building only files that Dawn requires
        step.addIncludePath("spirv-tools");
        step.addIncludePath("spirv-tools/include");
        step.addIncludePath("spirv-headers/include");
        step.addIncludePath("spirv-gen");

        const src_path = "spirv-tools/source/";
        step.addCSourceFiles(&.{
            // src_path ++ "util/bit_vector.cpp",
            src_path ++ "util/parse_number.cpp",
            src_path ++ "util/string_utils.cpp",
            src_path ++ "assembly_grammar.cpp",
            src_path ++ "binary.cpp",
            src_path ++ "diagnostic.cpp",
            src_path ++ "disassemble.cpp",
            src_path ++ "enum_string_mapping.cpp",
            src_path ++ "ext_inst.cpp",
            src_path ++ "extensions.cpp",
            src_path ++ "libspirv.cpp",
            src_path ++ "name_mapper.cpp",
            src_path ++ "opcode.cpp",
            src_path ++ "operand.cpp",
            src_path ++ "parsed_operand.cpp",
            src_path ++ "print.cpp",
            // src_path ++ "software_version.cpp",
            src_path ++ "spirv_endian.cpp",
            // src_path ++ "spirv_fuzzer_options.cpp",
            // src_path ++ "spirv_optimizer_options.cpp",
            // src_path ++ "spirv_reducer_options.cpp",
            src_path ++ "spirv_target_env.cpp",
            src_path ++ "spirv_validator_options.cpp",
            src_path ++ "table.cpp",
            src_path ++ "text.cpp",
            src_path ++ "text_handler.cpp",
            src_path ++ "val/validate.cpp",
            src_path ++ "val/validate_adjacency.cpp",
            src_path ++ "val/validate_annotation.cpp",
            src_path ++ "val/validate_arithmetics.cpp",
            src_path ++ "val/validate_atomics.cpp",
            src_path ++ "val/validate_barriers.cpp",
            src_path ++ "val/validate_bitwise.cpp",
            src_path ++ "val/validate_builtins.cpp",
            src_path ++ "val/validate_capability.cpp",
            src_path ++ "val/validate_cfg.cpp",
            src_path ++ "val/validate_composites.cpp",
            src_path ++ "val/validate_constants.cpp",
            src_path ++ "val/validate_conversion.cpp",
            src_path ++ "val/validate_debug.cpp",
            src_path ++ "val/validate_decorations.cpp",
            src_path ++ "val/validate_derivatives.cpp",
            src_path ++ "val/validate_extensions.cpp",
            src_path ++ "val/validate_execution_limitations.cpp",
            src_path ++ "val/validate_function.cpp",
            src_path ++ "val/validate_id.cpp",
            src_path ++ "val/validate_image.cpp",
            src_path ++ "val/validate_interfaces.cpp",
            src_path ++ "val/validate_instruction.cpp",
            src_path ++ "val/validate_layout.cpp",
            src_path ++ "val/validate_literals.cpp",
            src_path ++ "val/validate_logicals.cpp",
            src_path ++ "val/validate_memory.cpp",
            src_path ++ "val/validate_memory_semantics.cpp",
            src_path ++ "val/validate_mesh_shading.cpp",
            src_path ++ "val/validate_misc.cpp",
            src_path ++ "val/validate_mode_setting.cpp",
            src_path ++ "val/validate_non_uniform.cpp",
            src_path ++ "val/validate_primitives.cpp",
            src_path ++ "val/validate_ray_query.cpp",
            src_path ++ "val/validate_ray_tracing.cpp",
            src_path ++ "val/validate_ray_tracing_reorder.cpp",
            src_path ++ "val/validate_scopes.cpp",
            src_path ++ "val/validate_small_type_uses.cpp",
            src_path ++ "val/validate_type.cpp",
            src_path ++ "val/basic_block.cpp",
            src_path ++ "val/construct.cpp",
            src_path ++ "val/function.cpp",
            src_path ++ "val/instruction.cpp",
            src_path ++ "val/validation_state.cpp",
        }, c_flags);
        step.addCSourceFiles(&.{
            // src_path ++ "opt/fix_func_call_arguments.cpp",
            // src_path ++ "opt/aggressive_dead_code_elim_pass.cpp",
            // src_path ++ "opt/amd_ext_to_khr.cpp",
            // src_path ++ "opt/analyze_live_input_pass.cpp",
            src_path ++ "opt/basic_block.cpp",
            // src_path ++ "opt/block_merge_pass.cpp",
            // src_path ++ "opt/block_merge_util.cpp",
            src_path ++ "opt/build_module.cpp",
            // src_path ++ "opt/ccp_pass.cpp",
            // src_path ++ "opt/cfg_cleanup_pass.cpp",
            src_path ++ "opt/cfg.cpp",
            // src_path ++ "opt/code_sink.cpp",
            // src_path ++ "opt/combine_access_chains.cpp",
            // src_path ++ "opt/compact_ids_pass.cpp",
            src_path ++ "opt/composite.cpp",
            src_path ++ "opt/const_folding_rules.cpp",
            src_path ++ "opt/constants.cpp",
            // src_path ++ "opt/control_dependence.cpp",
            // src_path ++ "opt/convert_to_sampled_image_pass.cpp",
            // src_path ++ "opt/convert_to_half_pass.cpp",
            // src_path ++ "opt/copy_prop_arrays.cpp",
            // src_path ++ "opt/dataflow.cpp",
            // src_path ++ "opt/dead_branch_elim_pass.cpp",
            // src_path ++ "opt/dead_insert_elim_pass.cpp",
            // src_path ++ "opt/dead_variable_elimination.cpp",
            src_path ++ "opt/decoration_manager.cpp",
            src_path ++ "opt/debug_info_manager.cpp",
            src_path ++ "opt/def_use_manager.cpp",
            // src_path ++ "opt/desc_sroa.cpp",
            // src_path ++ "opt/desc_sroa_util.cpp",
            src_path ++ "opt/dominator_analysis.cpp",
            src_path ++ "opt/dominator_tree.cpp",
            // src_path ++ "opt/eliminate_dead_constant_pass.cpp",
            // src_path ++ "opt/eliminate_dead_functions_pass.cpp",
            // src_path ++ "opt/eliminate_dead_functions_util.cpp",
            // src_path ++ "opt/eliminate_dead_io_components_pass.cpp",
            // src_path ++ "opt/eliminate_dead_members_pass.cpp",
            // src_path ++ "opt/eliminate_dead_output_stores_pass.cpp",
            src_path ++ "opt/feature_manager.cpp",
            // src_path ++ "opt/fix_storage_class.cpp",
            // src_path ++ "opt/flatten_decoration_pass.cpp",
            src_path ++ "opt/fold.cpp",
            src_path ++ "opt/folding_rules.cpp",
            // src_path ++ "opt/fold_spec_constant_op_and_composite_pass.cpp",
            // src_path ++ "opt/freeze_spec_constant_value_pass.cpp",
            src_path ++ "opt/function.cpp",
            // src_path ++ "opt/graphics_robust_access_pass.cpp",
            // src_path ++ "opt/if_conversion.cpp",
            // src_path ++ "opt/inline_exhaustive_pass.cpp",
            // src_path ++ "opt/inline_opaque_pass.cpp",
            src_path ++ "opt/inline_pass.cpp",
            // src_path ++ "opt/inst_bindless_check_pass.cpp",
            // src_path ++ "opt/inst_buff_addr_check_pass.cpp",
            // src_path ++ "opt/inst_debug_printf_pass.cpp",
            src_path ++ "opt/instruction.cpp",
            src_path ++ "opt/instruction_list.cpp",
            // src_path ++ "opt/instrument_pass.cpp",
            // src_path ++ "opt/interface_var_sroa.cpp",
            // src_path ++ "opt/interp_fixup_pass.cpp",
            src_path ++ "opt/ir_context.cpp",
            src_path ++ "opt/ir_loader.cpp",
            // src_path ++ "opt/licm_pass.cpp",
            // src_path ++ "opt/liveness.cpp",
            // src_path ++ "opt/local_access_chain_convert_pass.cpp",
            // src_path ++ "opt/local_redundancy_elimination.cpp",
            // src_path ++ "opt/local_single_block_elim_pass.cpp",
            // src_path ++ "opt/local_single_store_elim_pass.cpp",
            src_path ++ "opt/loop_dependence.cpp",
            src_path ++ "opt/loop_dependence_helpers.cpp",
            src_path ++ "opt/loop_descriptor.cpp",
            // src_path ++ "opt/loop_fission.cpp",
            // src_path ++ "opt/loop_fusion.cpp",
            // src_path ++ "opt/loop_fusion_pass.cpp",
            // src_path ++ "opt/loop_peeling.cpp",
            src_path ++ "opt/loop_utils.cpp",
            // src_path ++ "opt/loop_unroller.cpp",
            // src_path ++ "opt/loop_unswitch_pass.cpp",
            src_path ++ "opt/mem_pass.cpp",
            // src_path ++ "opt/merge_return_pass.cpp",
            src_path ++ "opt/module.cpp",
            // src_path ++ "opt/optimizer.cpp",
            src_path ++ "opt/pass.cpp",
            // src_path ++ "opt/pass_manager.cpp",
            // src_path ++ "opt/private_to_local_pass.cpp",
            // src_path ++ "opt/propagator.cpp",
            // src_path ++ "opt/reduce_load_size.cpp",
            // src_path ++ "opt/redundancy_elimination.cpp",
            // src_path ++ "opt/register_pressure.cpp",
            // src_path ++ "opt/relax_float_ops_pass.cpp",
            // src_path ++ "opt/remove_dontinline_pass.cpp",
            // src_path ++ "opt/remove_duplicates_pass.cpp",
            // src_path ++ "opt/remove_unused_interface_variables_pass.cpp",
            // src_path ++ "opt/replace_desc_array_access_using_var_index.cpp",
            // src_path ++ "opt/replace_invalid_opc.cpp",
            src_path ++ "opt/scalar_analysis.cpp",
            src_path ++ "opt/scalar_analysis_simplification.cpp",
            // src_path ++ "opt/scalar_replacement_pass.cpp",
            // src_path ++ "opt/set_spec_constant_default_value_pass.cpp",
            // src_path ++ "opt/simplification_pass.cpp",
            // src_path ++ "opt/spread_volatile_semantics.cpp",
            // src_path ++ "opt/ssa_rewrite_pass.cpp",
            // src_path ++ "opt/strength_reduction_pass.cpp",
            // src_path ++ "opt/strip_debug_info_pass.cpp",
            // src_path ++ "opt/strip_nonsemantic_info_pass.cpp",
            src_path ++ "opt/struct_cfg_analysis.cpp",
            src_path ++ "opt/type_manager.cpp",
            src_path ++ "opt/types.cpp",
            // src_path ++ "opt/unify_const_pass.cpp",
            // src_path ++ "opt/upgrade_memory_model.cpp",
            src_path ++ "opt/value_number_table.cpp",
            // src_path ++ "opt/vector_dce.cpp",
            // src_path ++ "opt/workaround1209.cpp",
            // src_path ++ "opt/wrap_opkill.cpp",
        }, c_flags);
    }

    { // abseil-cpp, NOTE: building only files that Dawn requires
        step.addIncludePath("abseil-cpp");

        const src_path = "abseil-cpp/absl/";
        step.addCSourceFiles(&.{
            src_path ++ "strings/ascii.cc",
            src_path ++ "strings/charconv.cc",
            src_path ++ "strings/match.cc",
            src_path ++ "strings/numbers.cc",
            src_path ++ "strings/internal/charconv_bigint.cc",
            src_path ++ "strings/internal/charconv_parse.cc",
            src_path ++ "strings/internal/memutil.cc",
            src_path ++ "strings/internal/str_format/arg.cc",
            src_path ++ "strings/internal/str_format/bind.cc",
            src_path ++ "strings/internal/str_format/extension.cc",
            src_path ++ "strings/internal/str_format/float_conversion.cc",
            src_path ++ "strings/internal/str_format/output.cc",
            src_path ++ "strings/internal/str_format/parser.cc",
            src_path ++ "base/internal/raw_logging.cc",
            src_path ++ "numeric/int128.cc",
        }, c_flags);
    }
}

pub fn build(b: *std.build.Builder) void {
    const target = b.standardTargetOptions(.{});
    const build_mode = b.standardReleaseOptions();
    const options = DawnOptions.standard(b, target.os_tag orelse @import("builtin").target.os.tag);

    const shared_lib = b.addSharedLibrary("webgpu_dawn", null, .unversioned);
    shared_lib.setTarget(target);
    shared_lib.setBuildMode(build_mode);
    link(shared_lib, options, "");
    shared_lib.defineCMacro("WGPU_IMPLEMENTATION", null);
    shared_lib.defineCMacro("WGPU_SHARED_LIBRARY", null);
    shared_lib.install();

    const tests = b.addTest("webgpu.zig");
    tests.setTarget(target);
    tests.setBuildMode(build_mode);
    tests.linkLibrary(shared_lib);
    b.step("test", "Run library tests").dependOn(&tests.step);
}
