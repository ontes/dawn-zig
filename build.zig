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
};

pub fn addDawn(m: *std.Build.Module, options: DawnOptions) void {
    const b = m.owner;
    const os = m.resolved_target.?.result.os;
    const optimize = m.optimize.?;

    const flags = &[_][]const u8{ "-std=c++17", "-g0", "-fvisibility=hidden" };

    m.link_libcpp = true;

    if (os.tag == .windows) {
        m.addIncludePath(b.path("windows-sdk/include"));
        m.addCMacro("_Maybenull_", ""); // fix for dxcapi.h
    }

    { // dawn
        m.addIncludePath(b.path("dawn/include"));
        m.addIncludePath(b.path("dawn-gen/include"));

        m.addIncludePath(b.path("dawn/src"));
        m.addIncludePath(b.path("dawn-gen/src"));

        if (optimize == .Debug)
            m.addCMacro("DAWN_ENABLE_ASSERTS", "1");
        if (options.enable_d3d12)
            m.addCMacro("DAWN_ENABLE_BACKEND_D3D12", "1");
        if (options.enable_metal)
            m.addCMacro("DAWN_ENABLE_BACKEND_METAL", "1");
        if (options.enable_null)
            m.addCMacro("DAWN_ENABLE_BACKEND_NULL", "1");
        if (options.enable_opengl)
            m.addCMacro("DAWN_ENABLE_BACKEND_DESKTOP_GL", "1");
        if (options.enable_opengles)
            m.addCMacro("DAWN_ENABLE_BACKEND_OPENGLES", "1");
        if (options.enable_opengl or options.enable_opengles)
            m.addCMacro("DAWN_ENABLE_BACKEND_OPENGL", "1");
        if (options.enable_vulkan)
            m.addCMacro("DAWN_ENABLE_BACKEND_VULKAN", "1");
        if (options.use_wayland)
            m.addCMacro("DAWN_USE_WAYLAND", "1");
        if (options.use_x11)
            m.addCMacro("DAWN_USE_X11", "1");
        if (os.tag == .windows) {
            m.addCMacro("NOMINMAX", "1");
            m.addCMacro("WIN32_LEAN_AND_MEAN", "1");
        }

        m.addCSourceFiles(.{
            .root = b.path("dawn/src/dawn/common"),
            .files = &.{
                "Assert.cpp",
                "DynamicLib.cpp",
                "GPUInfo.cpp",
                "Log.cpp",
                "Math.cpp",
                "RefCounted.cpp",
                "Result.cpp",
                "SlabAllocator.cpp",
                "SystemUtils.cpp",
            },
            .flags = flags,
        });
        m.addCSourceFile(.{ .file = b.path("dawn-gen/src/dawn/common/GPUInfo_autogen.cpp"), .flags = flags });
        if (os.tag == .windows)
            m.addCSourceFile(.{ .file = b.path("dawn/src/dawn/common/WindowsUtils.cpp"), .flags = flags });
        if (os.tag == .macos)
            m.addCSourceFile(.{ .file = b.path("dawn/src/dawn/common/SystemUtils_mac.mm"), .flags = flags });

        m.addCSourceFiles(.{
            .root = b.path("dawn/src/dawn/platform"),
            .files = &.{
                "DawnPlatform.cpp",
                "WorkerThread.cpp",
                "tracing/EventTracer.cpp",
            },
            .flags = flags,
        });

        m.addCSourceFiles(.{
            .root = b.path("dawn/src/dawn/native"),
            .files = &.{
                "DawnNative.cpp",
                "Adapter.cpp",
                "ApplyClearColorValueWithDrawHelper.cpp",
                "AsyncTask.cpp",
                "AttachmentState.cpp",
                "BackendConnection.cpp",
                "BindGroup.cpp",
                "BindGroupLayout.cpp",
                "BindingInfo.cpp",
                "Blob.cpp",
                "BlobCache.cpp",
                "BuddyAllocator.cpp",
                "BuddyMemoryAllocator.cpp",
                "Buffer.cpp",
                "CachedObject.cpp",
                "CacheKey.cpp",
                "CacheRequest.cpp",
                "CallbackTaskManager.cpp",
                "CommandAllocator.cpp",
                "CommandBuffer.cpp",
                "CommandBufferStateTracker.cpp",
                "CommandEncoder.cpp",
                "CommandValidation.cpp",
                "Commands.cpp",
                "CompilationMessages.cpp",
                "ComputePassEncoder.cpp",
                "ComputePipeline.cpp",
                "CopyTextureForBrowserHelper.cpp",
                "CreatePipelineAsyncTask.cpp",
                "Device.cpp",
                "DynamicUploader.cpp",
                "EncodingContext.cpp",
                "Error.cpp",
                "ErrorData.cpp",
                "ErrorInjector.cpp",
                "ErrorScope.cpp",
                "Features.cpp",
                "ExternalTexture.cpp",
                "IndirectDrawMetadata.cpp",
                "IndirectDrawValidationEncoder.cpp",
                "ObjectContentHasher.cpp",
                "Format.cpp",
                "Instance.cpp",
                "InternalPipelineStore.cpp",
                "Limits.cpp",
                "ObjectBase.cpp",
                "PassResourceUsage.cpp",
                "PassResourceUsageTracker.cpp",
                "PerStage.cpp",
                "Pipeline.cpp",
                "PipelineCache.cpp",
                "PipelineLayout.cpp",
                "PooledResourceMemoryAllocator.cpp",
                "ProgrammableEncoder.cpp",
                "QueryHelper.cpp",
                "QuerySet.cpp",
                "Queue.cpp",
                "RefCountedWithExternalCount.cpp",
                "RenderBundle.cpp",
                "RenderBundleEncoder.cpp",
                "RenderEncoderBase.cpp",
                "RenderPassEncoder.cpp",
                "RenderPipeline.cpp",
                "ResourceMemoryAllocation.cpp",
                "RingBufferAllocator.cpp",
                "Sampler.cpp",
                "ScratchBuffer.cpp",
                "ShaderModule.cpp",
                "StagingBuffer.cpp",
                "StreamImplTint.cpp",
                "Subresource.cpp",
                // "Surface.cpp",
                "SwapChain.cpp",
                "Texture.cpp",
                "TintUtils.cpp",
                "Toggles.cpp",
                "VertexFormat.cpp",
                "webgpu_absl_format.cpp",
                "stream/BlobSource.cpp",
                "stream/ByteVectorSink.cpp",
                "stream/Stream.cpp",
                "utils/WGPUHelpers.cpp",
            },
            .flags = flags,
        });
        // modified Surface.cpp with fixed Windows compatibility
        m.addCSourceFile(.{ .file = b.path("Surface.cpp"), .flags = flags });
        m.addCSourceFiles(.{
            .root = b.path("dawn-gen/src/dawn/native"),
            .files = &.{
                "ChainUtils_autogen.cpp",
                "ObjectType_autogen.cpp",
                "ProcTable.cpp",
                "ValidationUtils_autogen.cpp",
                "webgpu_absl_format_autogen.cpp",
                "webgpu_StreamImpl_autogen.cpp",
                "wgpu_structs_autogen.cpp",
            },
            .flags = flags,
        });
        if (options.use_x11) {
            m.linkSystemLibrary("X11", .{});
            m.addCSourceFile(.{ .file = b.path("dawn/src/dawn/native/XlibXcbFunctions.cpp"), .flags = flags });
        }
        if (os.tag == .windows) {
            m.linkSystemLibrary("user32", .{});
        }
        if (options.enable_d3d12) {
            m.addCSourceFiles(.{
                .root = b.path("dawn/src/dawn/native/d3d12"),
                .files = &.{
                    "D3D12Backend.cpp",
                    "AdapterD3D12.cpp",
                    "BackendD3D12.cpp",
                    "BindGroupD3D12.cpp",
                    "BindGroupLayoutD3D12.cpp",
                    "BlobD3D12.cpp",
                    "BufferD3D12.cpp",
                    "CPUDescriptorHeapAllocationD3D12.cpp",
                    "CommandAllocatorManager.cpp",
                    "CommandBufferD3D12.cpp",
                    "CommandRecordingContext.cpp",
                    "ComputePipelineD3D12.cpp",
                    "D3D11on12Util.cpp",
                    "D3D12Error.cpp",
                    "D3D12Info.cpp",
                    "DeviceD3D12.cpp",
                    "ExternalImageDXGIImpl.cpp",
                    "FenceD3D12.cpp",
                    "GPUDescriptorHeapAllocationD3D12.cpp",
                    "HeapAllocatorD3D12.cpp",
                    "HeapD3D12.cpp",
                    "NativeSwapChainImplD3D12.cpp",
                    "PageableD3D12.cpp",
                    "PipelineLayoutD3D12.cpp",
                    "PlatformFunctions.cpp",
                    "QuerySetD3D12.cpp",
                    "QueueD3D12.cpp",
                    "RenderPassBuilderD3D12.cpp",
                    "RenderPipelineD3D12.cpp",
                    "ResidencyManagerD3D12.cpp",
                    "ResourceAllocatorManagerD3D12.cpp",
                    "ResourceHeapAllocationD3D12.cpp",
                    "SamplerD3D12.cpp",
                    "SamplerHeapCacheD3D12.cpp",
                    "ShaderModuleD3D12.cpp",
                    "ShaderVisibleDescriptorAllocatorD3D12.cpp",
                    "StagingBufferD3D12.cpp",
                    "StagingDescriptorAllocatorD3D12.cpp",
                    "StreamImplD3D12.cpp",
                    "SwapChainD3D12.cpp",
                    "TextureCopySplitter.cpp",
                    "TextureD3D12.cpp",
                    "UtilsD3D12.cpp",
                },
                .flags = flags,
            });
            m.linkSystemLibrary("dxguid", .{});
        }
        if (options.enable_metal) {
            m.addCSourceFiles(.{
                .root = b.path("dawn/src/dawn/native/metal"),
                .files = &.{
                    "MetalBackend.mm",
                    "BackendMTL.mm",
                    "BindGroupLayoutMTL.mm",
                    "BindGroupMTL.mm",
                    "BufferMTL.mm",
                    "CommandBufferMTL.mm",
                    "CommandRecordingContext.mm",
                    "ComputePipelineMTL.mm",
                    "DeviceMTL.mm",
                    "PipelineLayoutMTL.mm",
                    "QueueMTL.mm",
                    "QuerySetMTL.mm",
                    "RenderPipelineMTL.mm",
                    "SamplerMTL.mm",
                    "ShaderModuleMTL.mm",
                    "StagingBufferMTL.mm",
                    "SwapChainMTL.mm",
                    "TextureMTL.mm",
                    "UtilsMetal.mm",
                },
                .flags = flags,
            });
            m.addCSourceFile(.{ .file = b.path("dawn/src/dawn/native/Surface_metal.mm"), .flags = flags });
            m.linkFramework("Cocoa", .{});
            m.linkFramework("IOKit", .{});
            m.linkFramework("IOSurface", .{});
            m.linkFramework("QuartzCore", .{});
            m.linkFramework("Metal", .{});
        }
        if (options.enable_null) {
            m.addCSourceFiles(.{
                .root = b.path("dawn/src/dawn/native/null"),
                .files = &.{
                    "NullBackend.cpp",
                    "DeviceNull.cpp",
                },
                .flags = flags,
            });
        }
        if (options.enable_opengl or options.enable_opengles or options.enable_vulkan)
            m.addCSourceFile(.{ .file = b.path("dawn/src/dawn/native/SpirvValidation.cpp"), .flags = flags });
        if (options.enable_opengl or options.enable_opengles) {
            m.addCSourceFiles(.{
                .root = b.path("dawn/src/dawn/native/opengl"),
                .files = &.{
                    "OpenGLBackend.cpp",
                    "AdapterGL.cpp",
                    "BackendGL.cpp",
                    "BindGroupGL.cpp",
                    "BindGroupLayoutGL.cpp",
                    "BufferGL.cpp",
                    "CommandBufferGL.cpp",
                    "ComputePipelineGL.cpp",
                    "ContextEGL.cpp",
                    "DeviceGL.cpp",
                    "EGLFunctions.cpp",
                    "GLFormat.cpp",
                    "NativeSwapChainImplGL.cpp",
                    "OpenGLFunctions.cpp",
                    "OpenGLVersion.cpp",
                    "PersistentPipelineStateGL.cpp",
                    "PipelineGL.cpp",
                    "PipelineLayoutGL.cpp",
                    "QuerySetGL.cpp",
                    "QueueGL.cpp",
                    "RenderPipelineGL.cpp",
                    "SamplerGL.cpp",
                    "ShaderModuleGL.cpp",
                    "SwapChainGL.cpp",
                    "TextureGL.cpp",
                    "UtilsEGL.cpp",
                    "UtilsGL.cpp",
                },
                .flags = flags,
            });
            m.addCSourceFile(.{ .file = b.path("dawn-gen/src/dawn/native/opengl/OpenGLFunctionsBase_autogen.cpp"), .flags = flags });
            m.addIncludePath(b.path("dawn/third_party/khronos"));
        }
        if (options.enable_vulkan) {
            m.addCSourceFiles(.{
                .root = b.path("dawn/src/dawn/native/vulkan"),
                .files = &.{
                    "VulkanBackend.cpp",
                    "AdapterVk.cpp",
                    "BackendVk.cpp",
                    "BindGroupLayoutVk.cpp",
                    "BindGroupVk.cpp",
                    "BufferVk.cpp",
                    "CommandBufferVk.cpp",
                    "ComputePipelineVk.cpp",
                    "DescriptorSetAllocator.cpp",
                    "DeviceVk.cpp",
                    "FencedDeleter.cpp",
                    "NativeSwapChainImplVk.cpp",
                    "PipelineCacheVk.cpp",
                    "PipelineLayoutVk.cpp",
                    "QuerySetVk.cpp",
                    "QueueVk.cpp",
                    "RenderPassCache.cpp",
                    "RenderPipelineVk.cpp",
                    "ResourceHeapVk.cpp",
                    "ResourceMemoryAllocatorVk.cpp",
                    "SamplerVk.cpp",
                    "ShaderModuleVk.cpp",
                    "StagingBufferVk.cpp",
                    "StreamImplVk.cpp",
                    "SwapChainVk.cpp",
                    "TextureVk.cpp",
                    "UtilsVulkan.cpp",
                    "VulkanError.cpp",
                    "VulkanExtensions.cpp",
                    "VulkanFunctions.cpp",
                    "VulkanInfo.cpp",
                    "external_memory/MemoryService.cpp",
                },
                .flags = flags,
            });
            if (os.tag == .linux) {
                m.addCSourceFiles(.{
                    .root = b.path("dawn/src/dawn/native/vulkan"),
                    .files = &.{
                        "external_memory/MemoryServiceOpaqueFD.cpp",
                        "external_semaphore/SemaphoreServiceFD.cpp",
                    },
                    .flags = flags,
                });
            } else {
                m.addCSourceFiles(.{
                    .root = b.path("dawn/src/dawn/native/vulkan"),
                    .files = &.{
                        "external_memory/MemoryServiceNull.cpp",
                        "external_semaphore/SemaphoreServiceNull.cpp",
                    },
                    .flags = flags,
                });
            }
            m.addIncludePath(b.path("vulkan-headers/include"));
            m.addIncludePath(b.path("vulkan-tools"));
        }

        m.addCSourceFile(.{ .file = b.path("dawn-gen/src/dawn/native/webgpu_dawn_native_proc.cpp"), .flags = flags });
    }

    { // tint
        m.addIncludePath(b.path("dawn"));
        m.addIncludePath(b.path("dawn/include"));

        m.addCMacro("TINT_BUILD_WGSL_READER", "1");
        m.addCMacro("TINT_BUILD_WGSL_WRITER", "1");
        if (options.enable_vulkan) {
            m.addCMacro("TINT_BUILD_SPV_READER", "1");
            m.addCMacro("TINT_BUILD_SPV_WRITER", "1");
        }
        if (options.enable_opengl or options.enable_opengles)
            m.addCMacro("TINT_BUILD_GLSL_WRITER", "1");
        if (options.enable_d3d12)
            m.addCMacro("TINT_BUILD_HLSL_WRITER", "1");
        if (options.enable_metal)
            m.addCMacro("TINT_BUILD_MSL_WRITER", "1");

        m.addCSourceFiles(.{
            .root = b.path("dawn/src/tint"),
            .files = &.{
                "debug.cc",
                "source.cc",
                "diagnostic/diagnostic.cc",
                "diagnostic/formatter.cc",
                "diagnostic/printer.cc",
                "utils/debugger.cc",
            },
            .flags = flags,
        });
        m.addCSourceFiles(.{
            .root = b.path("dawn/src/tint"),
            .files = &.{
                "ast/alias.cc",
                "ast/array.cc",
                "ast/assignment_statement.cc",
                "ast/ast_type.cc",
                "ast/atomic.cc",
                "ast/attribute.cc",
                "ast/binary_expression.cc",
                "ast/binding_attribute.cc",
                "ast/bitcast_expression.cc",
                "ast/block_statement.cc",
                "ast/bool_literal_expression.cc",
                "ast/bool.cc",
                "ast/break_if_statement.cc",
                "ast/break_statement.cc",
                "ast/builtin_attribute.cc",
                "ast/call_expression.cc",
                "ast/call_statement.cc",
                "ast/case_selector.cc",
                "ast/case_statement.cc",
                "ast/compound_assignment_statement.cc",
                "ast/const.cc",
                "ast/continue_statement.cc",
                "ast/depth_multisampled_texture.cc",
                "ast/depth_texture.cc",
                "ast/disable_validation_attribute.cc",
                "ast/discard_statement.cc",
                "ast/enable.cc",
                "ast/expression.cc",
                "ast/external_texture.cc",
                "ast/f16.cc",
                "ast/f32.cc",
                "ast/float_literal_expression.cc",
                "ast/for_loop_statement.cc",
                "ast/function.cc",
                "ast/group_attribute.cc",
                "ast/i32.cc",
                "ast/id_attribute.cc",
                "ast/identifier_expression.cc",
                "ast/if_statement.cc",
                "ast/increment_decrement_statement.cc",
                "ast/index_accessor_expression.cc",
                "ast/int_literal_expression.cc",
                "ast/internal_attribute.cc",
                "ast/invariant_attribute.cc",
                "ast/let.cc",
                "ast/literal_expression.cc",
                "ast/location_attribute.cc",
                "ast/loop_statement.cc",
                "ast/matrix.cc",
                "ast/member_accessor_expression.cc",
                "ast/module.cc",
                "ast/multisampled_texture.cc",
                "ast/node.cc",
                "ast/override.cc",
                "ast/parameter.cc",
                "ast/phony_expression.cc",
                "ast/pipeline_stage.cc",
                "ast/pointer.cc",
                "ast/return_statement.cc",
                "ast/sampled_texture.cc",
                "ast/sampler.cc",
                "ast/stage_attribute.cc",
                "ast/statement.cc",
                "ast/static_assert.cc",
                "ast/storage_texture.cc",
                "ast/stride_attribute.cc",
                "ast/struct_member_align_attribute.cc",
                "ast/struct_member_offset_attribute.cc",
                "ast/struct_member_size_attribute.cc",
                "ast/struct_member.cc",
                "ast/struct.cc",
                "ast/switch_statement.cc",
                "ast/texture.cc",
                "ast/type_decl.cc",
                "ast/type_name.cc",
                "ast/u32.cc",
                "ast/unary_op_expression.cc",
                "ast/unary_op.cc",
                "ast/var.cc",
                "ast/variable_decl_statement.cc",
                "ast/variable.cc",
                "ast/vector.cc",
                "ast/void.cc",
                "ast/while_statement.cc",
                "ast/workgroup_attribute.cc",
                "castable.cc",
                "clone_context.cc",
                "constant/composite.cc",
                "constant/scalar.cc",
                "constant/splat.cc",
                "constant/node.cc",
                "constant/value.cc",
                "demangler.cc",
                "inspector/entry_point.cc",
                "inspector/inspector.cc",
                "inspector/resource_binding.cc",
                "inspector/scalar.cc",
                "number.cc",
                "program_builder.cc",
                "program_id.cc",
                "program.cc",
                "reader/reader.cc",
                "resolver/const_eval.cc",
                "resolver/dependency_graph.cc",
                "resolver/intrinsic_table.cc",
                "resolver/resolver.cc",
                "resolver/sem_helper.cc",
                "resolver/uniformity.cc",
                "resolver/validator.cc",
                "sem/array_count.cc",
                "sem/behavior.cc",
                "sem/block_statement.cc",
                "sem/break_if_statement.cc",
                "sem/builtin.cc",
                "sem/call_target.cc",
                "sem/call.cc",
                "sem/expression.cc",
                "sem/for_loop_statement.cc",
                "sem/function.cc",
                "sem/if_statement.cc",
                "sem/index_accessor_expression.cc",
                "sem/info.cc",
                "sem/load.cc",
                "sem/loop_statement.cc",
                "sem/materialize.cc",
                "sem/member_accessor_expression.cc",
                "sem/module.cc",
                "sem/node.cc",
                "sem/statement.cc",
                "sem/struct.cc",
                "sem/switch_statement.cc",
                "sem/type_initializer.cc",
                "sem/type_conversion.cc",
                "sem/variable.cc",
                "sem/while_statement.cc",
                "symbol_table.cc",
                "symbol.cc",
                "tint.cc",
                "text/unicode.cc",
                "transform/add_empty_entry_point.cc",
                "transform/add_block_attribute.cc",
                "transform/array_length_from_uniform.cc",
                "transform/binding_remapper.cc",
                "transform/builtin_polyfill.cc",
                "transform/calculate_array_length.cc",
                "transform/clamp_frag_depth.cc",
                "transform/canonicalize_entry_point_io.cc",
                "transform/combine_samplers.cc",
                "transform/decompose_memory_access.cc",
                "transform/decompose_strided_array.cc",
                "transform/decompose_strided_matrix.cc",
                "transform/demote_to_helper.cc",
                "transform/direct_variable_access.cc",
                "transform/disable_uniformity_analysis.cc",
                "transform/expand_compound_assignment.cc",
                "transform/first_index_offset.cc",
                "transform/for_loop_to_loop.cc",
                "transform/localize_struct_array_assignment.cc",
                "transform/manager.cc",
                "transform/merge_return.cc",
                "transform/module_scope_var_to_entry_point_param.cc",
                "transform/multiplanar_external_texture.cc",
                "transform/num_workgroups_from_uniform.cc",
                "transform/packed_vec3.cc",
                "transform/pad_structs.cc",
                "transform/preserve_padding.cc",
                "transform/promote_initializers_to_let.cc",
                "transform/promote_side_effects_to_decl.cc",
                "transform/remove_continue_in_switch.cc",
                "transform/remove_phonies.cc",
                "transform/remove_unreachable_statements.cc",
                "transform/renamer.cc",
                "transform/robustness.cc",
                "transform/simplify_pointers.cc",
                "transform/single_entry_point.cc",
                "transform/spirv_atomic.cc",
                "transform/std140.cc",
                "transform/substitute_override.cc",
                "transform/texture_1d_to_2d.cc",
                "transform/transform.cc",
                "transform/truncate_interstage_variables.cc",
                "transform/unshadow.cc",
                "transform/utils/get_insertion_point.cc",
                "transform/utils/hoist_to_decl_before.cc",
                "transform/var_for_dynamic_index.cc",
                "transform/vectorize_matrix_conversions.cc",
                "transform/vectorize_scalar_matrix_initializers.cc",
                "transform/vertex_pulling.cc",
                "transform/while_to_loop.cc",
                "transform/zero_init_workgroup_memory.cc",
                "type/abstract_float.cc",
                "type/abstract_int.cc",
                "type/abstract_numeric.cc",
                "type/array.cc",
                "type/array_count.cc",
                "type/atomic.cc",
                "type/bool.cc",
                "type/depth_multisampled_texture.cc",
                "type/depth_texture.cc",
                "type/external_texture.cc",
                "type/f16.cc",
                "type/f32.cc",
                "type/i32.cc",
                "type/manager.cc",
                "type/matrix.cc",
                "type/multisampled_texture.cc",
                "type/node.cc",
                "type/pointer.cc",
                "type/reference.cc",
                "type/sampled_texture.cc",
                "type/sampler.cc",
                "type/storage_texture.cc",
                "type/struct.cc",
                "type/texture.cc",
                "type/type.cc",
                "type/u32.cc",
                "type/unique_node.cc",
                "type/vector.cc",
                "type/void.cc",
                "utils/string.cc",
                "writer/append_vector.cc",
                "writer/array_length_from_uniform_options.cc",
                "writer/check_supported_extensions.cc",
                "writer/flatten_bindings.cc",
                "writer/float_to_string.cc",
                "writer/generate_external_texture_bindings.cc",
                "writer/text_generator.cc",
                "writer/text.cc",
                "writer/writer.cc",
            },
            .flags = flags,
        });
        m.addCSourceFiles(.{
            .root = b.path("dawn/src/tint"),
            .files = &.{
                "ast/access.cc",
                "ast/address_space.cc",
                "ast/builtin_value.cc",
                "ast/extension.cc",
                "ast/interpolate_attribute.cc",
                "ast/texel_format.cc",
                "resolver/init_conv_intrinsic.cc",
                "sem/builtin_type.cc",
                "sem/parameter_usage.cc",
                "type/short_name.cc",
            },
            .flags = flags,
        });
        m.addCSourceFiles(.{
            .root = b.path("dawn/src/tint/reader/wgsl"),
            .files = &.{
                "lexer.cc",
                "parser.cc",
                "parser_impl.cc",
                "token.cc",
            },
            .flags = flags,
        });
        m.addCSourceFiles(.{
            .root = b.path("dawn/src/tint/writer/wgsl"),
            .files = &.{
                "generator.cc",
                "generator_impl.cc",
            },
            .flags = flags,
        });
        if (options.enable_vulkan) {
            m.addCSourceFiles(.{
                .root = b.path("dawn/src/tint/reader/spirv"),
                .files = &.{
                    "construct.cc",
                    "entry_point_info.cc",
                    "enum_converter.cc",
                    "function.cc",
                    "namer.cc",
                    "parser_type.cc",
                    "parser.cc",
                    "parser_impl.cc",
                    "usage.cc",
                },
                .flags = flags,
            });
            m.addCSourceFiles(.{
                .root = b.path("dawn/src/tint/writer/spirv"),
                .files = &.{
                    "binary_writer.cc",
                    "builder.cc",
                    "function.cc",
                    "generator.cc",
                    "generator_impl.cc",
                    "instruction.cc",
                    "operand.cc",
                },
                .flags = flags,
            });
        }
        if (options.enable_metal) {
            m.addCSourceFiles(.{
                .root = b.path("dawn/src/tint/writer/msl"),
                .files = &.{
                    "generator.cc",
                    "generator_impl.cc",
                },
                .flags = flags,
            });
        }
        if (options.enable_opengl or options.enable_opengles) {
            m.addCSourceFiles(.{
                .root = b.path("dawn/src/tint/writer/glsl"),
                .files = &.{
                    "generator.cc",
                    "generator_impl.cc",
                },
                .flags = flags,
            });
        }
        if (options.enable_d3d12) {
            m.addCSourceFiles(.{
                .root = b.path("dawn/src/tint/writer/hlsl"),
                .files = &.{
                    "generator.cc",
                    "generator_impl.cc",
                },
                .flags = flags,
            });
        }
    }

    { // spirv-tools, NOTE: building only files that Dawn requires
        m.addIncludePath(b.path("spirv-tools"));
        m.addIncludePath(b.path("spirv-tools/include"));
        m.addIncludePath(b.path("spirv-headers/include"));
        m.addIncludePath(b.path("spirv-gen"));

        m.addCSourceFiles(.{
            .root = b.path("spirv-tools/source"),
            .files = &.{
                // "util/bit_vector.cpp",
                "util/parse_number.cpp",
                "util/string_utils.cpp",
                "assembly_grammar.cpp",
                "binary.cpp",
                "diagnostic.cpp",
                "disassemble.cpp",
                "enum_string_mapping.cpp",
                "ext_inst.cpp",
                "extensions.cpp",
                "libspirv.cpp",
                "name_mapper.cpp",
                "opcode.cpp",
                "operand.cpp",
                "parsed_operand.cpp",
                "print.cpp",
                // "software_version.cpp",
                "spirv_endian.cpp",
                // "spirv_fuzzer_options.cpp",
                // "spirv_optimizer_options.cpp",
                // "spirv_reducer_options.cpp",
                "spirv_target_env.cpp",
                "spirv_validator_options.cpp",
                "table.cpp",
                "text.cpp",
                "text_handler.cpp",
                "val/validate.cpp",
                "val/validate_adjacency.cpp",
                "val/validate_annotation.cpp",
                "val/validate_arithmetics.cpp",
                "val/validate_atomics.cpp",
                "val/validate_barriers.cpp",
                "val/validate_bitwise.cpp",
                "val/validate_builtins.cpp",
                "val/validate_capability.cpp",
                "val/validate_cfg.cpp",
                "val/validate_composites.cpp",
                "val/validate_constants.cpp",
                "val/validate_conversion.cpp",
                "val/validate_debug.cpp",
                "val/validate_decorations.cpp",
                "val/validate_derivatives.cpp",
                "val/validate_extensions.cpp",
                "val/validate_execution_limitations.cpp",
                "val/validate_function.cpp",
                "val/validate_id.cpp",
                "val/validate_image.cpp",
                "val/validate_interfaces.cpp",
                "val/validate_instruction.cpp",
                "val/validate_layout.cpp",
                "val/validate_literals.cpp",
                "val/validate_logicals.cpp",
                "val/validate_memory.cpp",
                "val/validate_memory_semantics.cpp",
                "val/validate_mesh_shading.cpp",
                "val/validate_misc.cpp",
                "val/validate_mode_setting.cpp",
                "val/validate_non_uniform.cpp",
                "val/validate_primitives.cpp",
                "val/validate_ray_query.cpp",
                "val/validate_ray_tracing.cpp",
                "val/validate_ray_tracing_reorder.cpp",
                "val/validate_scopes.cpp",
                "val/validate_small_type_uses.cpp",
                "val/validate_type.cpp",
                "val/basic_block.cpp",
                "val/construct.cpp",
                "val/function.cpp",
                "val/instruction.cpp",
                "val/validation_state.cpp",
            },
            .flags = flags,
        });
        m.addCSourceFiles(.{
            .root = b.path("spirv-tools/source"),
            .files = &.{
                // "opt/fix_func_call_arguments.cpp",
                // "opt/aggressive_dead_code_elim_pass.cpp",
                // "opt/amd_ext_to_khr.cpp",
                // "opt/analyze_live_input_pass.cpp",
                "opt/basic_block.cpp",
                // "opt/block_merge_pass.cpp",
                // "opt/block_merge_util.cpp",
                "opt/build_module.cpp",
                // "opt/ccp_pass.cpp",
                // "opt/cfg_cleanup_pass.cpp",
                "opt/cfg.cpp",
                // "opt/code_sink.cpp",
                // "opt/combine_access_chains.cpp",
                // "opt/compact_ids_pass.cpp",
                "opt/composite.cpp",
                "opt/const_folding_rules.cpp",
                "opt/constants.cpp",
                // "opt/control_dependence.cpp",
                // "opt/convert_to_sampled_image_pass.cpp",
                // "opt/convert_to_half_pass.cpp",
                // "opt/copy_prop_arrays.cpp",
                // "opt/dataflow.cpp",
                // "opt/dead_branch_elim_pass.cpp",
                // "opt/dead_insert_elim_pass.cpp",
                // "opt/dead_variable_elimination.cpp",
                "opt/decoration_manager.cpp",
                "opt/debug_info_manager.cpp",
                "opt/def_use_manager.cpp",
                // "opt/desc_sroa.cpp",
                // "opt/desc_sroa_util.cpp",
                "opt/dominator_analysis.cpp",
                "opt/dominator_tree.cpp",
                // "opt/eliminate_dead_constant_pass.cpp",
                // "opt/eliminate_dead_functions_pass.cpp",
                // "opt/eliminate_dead_functions_util.cpp",
                // "opt/eliminate_dead_io_components_pass.cpp",
                // "opt/eliminate_dead_members_pass.cpp",
                // "opt/eliminate_dead_output_stores_pass.cpp",
                "opt/feature_manager.cpp",
                // "opt/fix_storage_class.cpp",
                // "opt/flatten_decoration_pass.cpp",
                "opt/fold.cpp",
                "opt/folding_rules.cpp",
                // "opt/fold_spec_constant_op_and_composite_pass.cpp",
                // "opt/freeze_spec_constant_value_pass.cpp",
                "opt/function.cpp",
                // "opt/graphics_robust_access_pass.cpp",
                // "opt/if_conversion.cpp",
                // "opt/inline_exhaustive_pass.cpp",
                // "opt/inline_opaque_pass.cpp",
                "opt/inline_pass.cpp",
                // "opt/inst_bindless_check_pass.cpp",
                // "opt/inst_buff_addr_check_pass.cpp",
                // "opt/inst_debug_printf_pass.cpp",
                "opt/instruction.cpp",
                "opt/instruction_list.cpp",
                // "opt/instrument_pass.cpp",
                // "opt/interface_var_sroa.cpp",
                // "opt/interp_fixup_pass.cpp",
                "opt/ir_context.cpp",
                "opt/ir_loader.cpp",
                // "opt/licm_pass.cpp",
                // "opt/liveness.cpp",
                // "opt/local_access_chain_convert_pass.cpp",
                // "opt/local_redundancy_elimination.cpp",
                // "opt/local_single_block_elim_pass.cpp",
                // "opt/local_single_store_elim_pass.cpp",
                "opt/loop_dependence.cpp",
                "opt/loop_dependence_helpers.cpp",
                "opt/loop_descriptor.cpp",
                // "opt/loop_fission.cpp",
                // "opt/loop_fusion.cpp",
                // "opt/loop_fusion_pass.cpp",
                // "opt/loop_peeling.cpp",
                "opt/loop_utils.cpp",
                // "opt/loop_unroller.cpp",
                // "opt/loop_unswitch_pass.cpp",
                "opt/mem_pass.cpp",
                // "opt/merge_return_pass.cpp",
                "opt/module.cpp",
                // "opt/optimizer.cpp",
                "opt/pass.cpp",
                // "opt/pass_manager.cpp",
                // "opt/private_to_local_pass.cpp",
                // "opt/propagator.cpp",
                // "opt/reduce_load_size.cpp",
                // "opt/redundancy_elimination.cpp",
                // "opt/register_pressure.cpp",
                // "opt/relax_float_ops_pass.cpp",
                // "opt/remove_dontinline_pass.cpp",
                // "opt/remove_duplicates_pass.cpp",
                // "opt/remove_unused_interface_variables_pass.cpp",
                // "opt/replace_desc_array_access_using_var_index.cpp",
                // "opt/replace_invalid_opc.cpp",
                "opt/scalar_analysis.cpp",
                "opt/scalar_analysis_simplification.cpp",
                // "opt/scalar_replacement_pass.cpp",
                // "opt/set_spec_constant_default_value_pass.cpp",
                // "opt/simplification_pass.cpp",
                // "opt/spread_volatile_semantics.cpp",
                // "opt/ssa_rewrite_pass.cpp",
                // "opt/strength_reduction_pass.cpp",
                // "opt/strip_debug_info_pass.cpp",
                // "opt/strip_nonsemantic_info_pass.cpp",
                "opt/struct_cfg_analysis.cpp",
                "opt/type_manager.cpp",
                "opt/types.cpp",
                // "opt/unify_const_pass.cpp",
                // "opt/upgrade_memory_model.cpp",
                "opt/value_number_table.cpp",
                // "opt/vector_dce.cpp",
                // "opt/workaround1209.cpp",
                // "opt/wrap_opkill.cpp",
            },
            .flags = flags,
        });
    }

    { // abseil-cpp, NOTE: building only files that Dawn requires
        m.addIncludePath(b.path("abseil-cpp"));

        m.addCSourceFiles(.{
            .root = b.path("abseil-cpp/absl"),
            .files = &.{
                "strings/ascii.cc",
                "strings/charconv.cc",
                "strings/match.cc",
                "strings/numbers.cc",
                "strings/internal/charconv_bigint.cc",
                "strings/internal/charconv_parse.cc",
                "strings/internal/memutil.cc",
                "strings/internal/str_format/arg.cc",
                "strings/internal/str_format/bind.cc",
                "strings/internal/str_format/extension.cc",
                "strings/internal/str_format/float_conversion.cc",
                "strings/internal/str_format/output.cc",
                "strings/internal/str_format/parser.cc",
                "base/internal/raw_logging.cc",
                "numeric/int128.cc",
            },
            .flags = flags,
        });
    }
}

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const os = target.result.os;
    const options = DawnOptions{
        .enable_d3d12 = b.option(bool, "enable-d3d12", "enable DirectX 12 backend") orelse (os.tag == .windows),
        .enable_metal = b.option(bool, "enable-metal", "enable Metal backend") orelse (os.tag == .macos),
        .enable_null = b.option(bool, "enable-null", "enable Null backend") orelse true,
        .enable_opengl = b.option(bool, "enable-opengl", "enable OpenGL backend") orelse (os.tag == .linux),
        .enable_opengles = b.option(bool, "enable-opengles", "enable OpenGL ES backend") orelse (os.tag == .linux),
        .enable_vulkan = b.option(bool, "enable-vulkan", "enable Vulkan backend") orelse (os.tag == .windows or os.tag == .linux),
        .use_wayland = b.option(bool, "use-wayland", "use Wayland") orelse false,
        .use_x11 = b.option(bool, "use-x11", "use X11") orelse (os.tag == .linux),
    };

    const static_lib = b.addStaticLibrary(.{
        .name = "webgpu_dawn",
        .target = target,
        .optimize = optimize,
    });
    static_lib.linkLibCpp();
    addDawn(&static_lib.root_module, options);
    b.installArtifact(static_lib); // install static library by default

    const shared_lib = b.addSharedLibrary(.{
        .name = "webgpu_dawn",
        .target = target,
        .optimize = optimize,
    });
    addDawn(&shared_lib.root_module, options);
    shared_lib.root_module.addCMacro("WGPU_IMPLEMENTATION", "1");
    shared_lib.root_module.addCMacro("WGPU_SHARED_LIBRARY", "1");
    b.step("shared", "Build shared library").dependOn(&b.addInstallArtifact(shared_lib, .{}).step);

    const tests = b.addTest(.{
        .root_source_file = b.path("webgpu.zig"),
        .target = target,
        .optimize = optimize,
    });
    tests.linkLibrary(static_lib);
    b.step("test", "Run library tests").dependOn(&b.addRunArtifact(tests).step);
}
