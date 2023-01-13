const std = @import("std");

pub const whole_size = std.math.maxInt(u64);

extern fn wgpuCreateInstance(descriptor: *const InstanceDescriptor) *Instance;
pub const createInstance = wgpuCreateInstance;
extern fn wgpuGetProcAddress(device: *Device, procName: [*:0]const u8) ?*const Proc;
pub const getProcAddress = wgpuGetProcAddress;

pub const Adapter = opaque {
    extern fn wgpuAdapterEnumerateFeatures(adapter: *Adapter, features: ?[*]FeatureName) usize;
    pub const enumerateFeatures = wgpuAdapterEnumerateFeatures;
    extern fn wgpuAdapterGetLimits(adapter: *Adapter, limits: *SupportedLimits) bool;
    pub const getLimits = wgpuAdapterGetLimits;
    extern fn wgpuAdapterGetProperties(adapter: *Adapter, properties: *AdapterProperties) void;
    pub const getProperties = wgpuAdapterGetProperties;
    extern fn wgpuAdapterHasFeature(adapter: *Adapter, feature: FeatureName) bool;
    pub const hasFeature = wgpuAdapterHasFeature;
    extern fn wgpuAdapterRequestDevice(adapter: *Adapter, descriptor: *const DeviceDescriptor, callback: *const RequestDeviceCallback, userdata: ?*anyopaque) void;
    pub const requestDevice = wgpuAdapterRequestDevice;
};

pub const BindGroup = opaque {
    extern fn wgpuBindGroupSetLabel(bindGroup: *BindGroup, label: [*:0]const u8) void;
    pub const setLabel = wgpuBindGroupSetLabel;
};

pub const BindGroupLayout = opaque {
    extern fn wgpuBindGroupLayoutSetLabel(bind_group_layout: *BindGroupLayout, label: [*:0]const u8) void;
    pub const setLabel = wgpuBindGroupLayoutSetLabel;
};

pub const Buffer = opaque {
    extern fn wgpuBufferDestroy(buffer: *Buffer) void;
    pub const destroy = wgpuBufferDestroy;
    extern fn wgpuBufferGetConstMappedRange(buffer: *Buffer, offset: usize, size: usize) ?*const anyopaque;
    pub const getConstMappedRange = wgpuBufferGetConstMappedRange;
    extern fn wgpuBufferGetMappedRange(buffer: *Buffer, offset: usize, size: usize) ?*anyopaque;
    pub const getMappedRange = wgpuBufferGetMappedRange;
    extern fn wgpuGetMapState(buffer: *Buffer) BufferMapState;
    pub const getMapState = wgpuGetMapState;
    extern fn wgpuBufferGetSize(buffer: *Buffer) u64;
    pub const getSize = wgpuBufferGetSize;
    extern fn wgpuBufferGetUsage(buffer: *Buffer) BufferUsage;
    pub const getUsage = wgpuBufferGetUsage;
    extern fn wgpuBufferMapAsync(buffer: *Buffer, mode: MapMode, offset: usize, size: usize, callback: *const BufferMapCallback, userdata: ?*anyopaque) void;
    pub const mapAsync = wgpuBufferMapAsync;
    extern fn wgpuBufferSetLabel(buffer: *Buffer, label: [*:0]const u8) void;
    pub const setLabel = wgpuBufferSetLabel;
    extern fn wgpuBufferUnmap(buffer: *Buffer) void;
    pub const unmap = wgpuBufferUnmap;
};

pub const CommandBuffer = opaque {
    extern fn wgpuCommandBufferSetLabel(command_buffer: *CommandBuffer, label: [*:0]const u8) void;
    pub const setLabel = wgpuCommandBufferSetLabel;
};

pub const CommandEncoder = opaque {
    extern fn wgpuCommandEncoderBeginComputePass(command_encoder: *CommandEncoder, descriptor: *const ComputePassDescriptor) *ComputePassEncoder;
    pub const beginComputePass = wgpuCommandEncoderBeginComputePass;
    extern fn wgpuCommandEncoderBeginRenderPass(command_encoder: *CommandEncoder, descriptor: *const RenderPassDescriptor) *RenderPassEncoder;
    pub const beginRenderPass = wgpuCommandEncoderBeginRenderPass;
    extern fn wgpuCommandEncoderClearBuffer(command_encoder: *CommandEncoder, buffer: *Buffer, offset: u64, size: u64) void;
    pub const clearBuffer = wgpuCommandEncoderClearBuffer;
    extern fn wgpuCommandEncoderCopyBufferToBuffer(command_encoder: *CommandEncoder, source: *Buffer, source_offset: u64, destination: *Buffer, destination_offset: u64, size: u64) void;
    pub const copyBufferToBuffer = wgpuCommandEncoderCopyBufferToBuffer;
    extern fn wgpuCommandEncoderCopyBufferToTexture(command_encoder: *CommandEncoder, source: *const ImageCopyBuffer, destination: *const ImageCopyTexture, copy_size: *const Extent3D) void;
    pub const copyBufferToTexture = wgpuCommandEncoderCopyBufferToTexture;
    extern fn wgpuCommandEncoderCopyTextureToBuffer(command_encoder: *CommandEncoder, source: *const ImageCopyTexture, destination: *const ImageCopyBuffer, copy_size: *const Extent3D) void;
    pub const copyTextureToBuffer = wgpuCommandEncoderCopyTextureToBuffer;
    extern fn wgpuCommandEncoderCopyTextureToTexture(command_encoder: *CommandEncoder, source: *const ImageCopyTexture, destination: *const ImageCopyTexture, copy_size: *const Extent3D) void;
    pub const copyTextureToTexture = wgpuCommandEncoderCopyTextureToTexture;
    extern fn wgpuCommandEncoderFinish(command_encoder: *CommandEncoder, descriptor: *const CommandBufferDescriptor) *CommandBuffer;
    pub const finish = wgpuCommandEncoderFinish;
    extern fn wgpuCommandEncoderInsertDebugMarker(command_encoder: *CommandEncoder, marker_label: [*:0]const u8) void;
    pub const insertDebugMarker = wgpuCommandEncoderInsertDebugMarker;
    extern fn wgpuCommandEncoderPopDebugGroup(command_encoder: *CommandEncoder) void;
    pub const popDebugGroup = wgpuCommandEncoderPopDebugGroup;
    extern fn wgpuCommandEncoderPushDebugGroup(command_encoder: *CommandEncoder, group_label: [*:0]const u8) void;
    pub const pushDebugGroup = wgpuCommandEncoderPushDebugGroup;
    extern fn wgpuCommandEncoderResolveQuerySet(command_encoder: *CommandEncoder, query_set: *QuerySet, first_query: u32, query_count: u32, destination: *Buffer, destination_offset: u64) void;
    pub const resolveQuerySet = wgpuCommandEncoderResolveQuerySet;
    extern fn wgpuCommandEncoderSetLabel(command_encoder: *CommandEncoder, label: [*:0]const u8) void;
    pub const setLabel = wgpuCommandEncoderSetLabel;
    extern fn wgpuCommandEncoderWriteTimestamp(command_encoder: *CommandEncoder, query_set: *QuerySet, query_index: u32) void;
    pub const writeTimestamp = wgpuCommandEncoderWriteTimestamp;
};

pub const ComputePassEncoder = opaque {
    // extern fn wgpuComputePassEncoderDispatch(compute_pass_encoder: *ComputePassEncoder, workgroup_count_x: u32, workgroup_count_y: u32, workgroup_count_z: u32) void; // deprecated
    // pub const dispatch = wgpuComputePassEncoderDispatch;
    // extern fn wgpuComputePassEncoderDispatchIndirect(compute_pass_encoder: *ComputePassEncoder, indirect_buffer: *Buffer, indirect_offset: u64) void; // deprecated
    // pub const dispatchIndirect = wgpuComputePassEncoderDispatchIndirect;
    extern fn wgpuComputePassEncoderDispatchWorkgroups(compute_pass_encoder: *ComputePassEncoder, workgroup_count_x: u32, workgroup_count_y: u32, workgroup_count_z: u32) void;
    pub const dispatchWorkgroups = wgpuComputePassEncoderDispatchWorkgroups;
    extern fn wgpuComputePassEncoderDispatchWorkgroupsIndirect(compute_pass_encoder: *ComputePassEncoder, indirect_buffer: *Buffer, indirect_offset: u64) void;
    pub const dispatchWorkgroupsIndirect = wgpuComputePassEncoderDispatchWorkgroupsIndirect;
    extern fn wgpuComputePassEncoderEnd(compute_pass_encoder: *ComputePassEncoder) void;
    pub const end = wgpuComputePassEncoderEnd;
    // extern fn wgpuComputePassEncoderEndPass(compute_pass_encoder: *ComputePassEncoder) void; // deprecated
    // pub const endPass = wgpuComputePassEncoderEndPass;
    extern fn wgpuComputePassEncoderInsertDebugMarker(compute_pass_encoder: *ComputePassEncoder, marker_label: [*:0]const u8) void;
    pub const insertDebugMarker = wgpuComputePassEncoderInsertDebugMarker;
    extern fn wgpuComputePassEncoderPopDebugGroup(compute_pass_encoder: *ComputePassEncoder) void;
    pub const popDebugGroup = wgpuComputePassEncoderPopDebugGroup;
    extern fn wgpuComputePassEncoderPushDebugGroup(compute_pass_encoder: *ComputePassEncoder, group_label: [*:0]const u8) void;
    pub const pushDebugGroup = wgpuComputePassEncoderPushDebugGroup;
    extern fn wgpuComputePassEncoderSetBindGroup(compute_pass_encoder: *ComputePassEncoder, group_index: u32, group: *BindGroup, dynamic_offset_count: u32, dynamic_offsets: [*]const u32) void;
    pub const setBindGroup = wgpuComputePassEncoderSetBindGroup;
    extern fn wgpuComputePassEncoderSetLabel(compute_pass_encoder: *ComputePassEncoder, label: [*:0]const u8) void;
    pub const setLabel = wgpuComputePassEncoderSetLabel;
    extern fn wgpuComputePassEncoderSetPipeline(compute_pass_encoder: *ComputePassEncoder, pipeline: *ComputePipeline) void;
    pub const setPipeline = wgpuComputePassEncoderSetPipeline;
};

pub const ComputePipeline = opaque {
    extern fn wgpuComputePipelineGetBindGroupLayout(compute_pipeline: *ComputePipeline, group_index: u32) *BindGroupLayout;
    pub const getBindGroupLayout = wgpuComputePipelineGetBindGroupLayout;
    extern fn wgpuComputePipelineSetLabel(compute_pipeline: *ComputePipeline, label: [*:0]const u8) void;
    pub const setLabel = wgpuComputePipelineSetLabel;
};

pub const Device = opaque {
    extern fn wgpuDeviceCreateBindGroup(device: *Device, descriptor: *const BindGroupDescriptor) *BindGroup;
    pub const createBindGroup = wgpuDeviceCreateBindGroup;
    extern fn wgpuDeviceCreateBindGroupLayout(device: *Device, descriptor: *const BindGroupLayoutDescriptor) *BindGroupLayout;
    pub const createBindGroupLayout = wgpuDeviceCreateBindGroupLayout;
    extern fn wgpuDeviceCreateBuffer(device: *Device, descriptor: *const BufferDescriptor) *Buffer;
    pub const createBuffer = wgpuDeviceCreateBuffer;
    extern fn wgpuDeviceCreateCommandEncoder(device: *Device, descriptor: *const CommandEncoderDescriptor) *CommandEncoder;
    pub const createCommandEncoder = wgpuDeviceCreateCommandEncoder;
    extern fn wgpuDeviceCreateComputePipeline(device: *Device, descriptor: *const ComputePipelineDescriptor) *ComputePipeline;
    pub const createComputePipeline = wgpuDeviceCreateComputePipeline;
    extern fn wgpuDeviceCreateComputePipelineAsync(device: *Device, descriptor: *const ComputePipelineDescriptor, callback: *const CreateComputePipelineAsyncCallback, userdata: ?*anyopaque) void;
    pub const createComputePipelineAsync = wgpuDeviceCreateComputePipelineAsync;
    extern fn wgpuDeviceCreatePipelineLayout(device: *Device, descriptor: *const PipelineLayoutDescriptor) *PipelineLayout;
    pub const createPipelineLayout = wgpuDeviceCreatePipelineLayout;
    extern fn wgpuDeviceCreateQuerySet(device: *Device, descriptor: *const QuerySetDescriptor) *QuerySet;
    pub const createQuerySet = wgpuDeviceCreateQuerySet;
    extern fn wgpuDeviceCreateRenderBundleEncoder(device: *Device, descriptor: *const RenderBundleEncoderDescriptor) *RenderBundleEncoder;
    pub const createRenderBundleEncoder = wgpuDeviceCreateRenderBundleEncoder;
    extern fn wgpuDeviceCreateRenderPipeline(device: *Device, descriptor: *const RenderPipelineDescriptor) *RenderPipeline;
    pub const createRenderPipeline = wgpuDeviceCreateRenderPipeline;
    extern fn wgpuDeviceCreateRenderPipelineAsync(device: *Device, descriptor: *const RenderPipelineDescriptor, callback: *const CreateRenderPipelineAsyncCallback, userdata: ?*anyopaque) void;
    pub const createRenderPipelineAsync = wgpuDeviceCreateRenderPipelineAsync;
    extern fn wgpuDeviceCreateSampler(device: *Device, descriptor: *const SamplerDescriptor) *Sampler;
    pub const createSampler = wgpuDeviceCreateSampler;
    extern fn wgpuDeviceCreateShaderModule(device: *Device, descriptor: *const ShaderModuleDescriptor) *ShaderModule;
    pub const createShaderModule = wgpuDeviceCreateShaderModule;
    extern fn wgpuDeviceCreateSwapChain(device: *Device, surface: *Surface, descriptor: *const SwapChainDescriptor) *SwapChain;
    pub const createSwapChain = wgpuDeviceCreateSwapChain;
    extern fn wgpuDeviceCreateTexture(device: *Device, descriptor: *const TextureDescriptor) *Texture;
    pub const createTexture = wgpuDeviceCreateTexture;
    extern fn wgpuDeviceDestroy(device: *Device) void;
    pub const destroy = wgpuDeviceDestroy;
    extern fn wgpuDeviceEnumerateFeatures(device: *Device, features: ?[*]FeatureName) usize;
    pub const enumerateFeatures = wgpuDeviceEnumerateFeatures;
    extern fn wgpuDeviceGetLimits(device: *Device, limits: *SupportedLimits) bool;
    pub const getLimits = wgpuDeviceGetLimits;
    extern fn wgpuDeviceGetQueue(device: *Device) *Queue;
    pub const getQueue = wgpuDeviceGetQueue;
    extern fn wgpuDeviceHasFeature(device: *Device, feature: FeatureName) bool;
    pub const hasFeature = wgpuDeviceHasFeature;
    extern fn wgpuDevicePopErrorScope(device: *Device, callback: *const ErrorCallback, userdata: ?*anyopaque) bool;
    pub const popErrorScope = wgpuDevicePopErrorScope;
    extern fn wgpuDevicePushErrorScope(device: *Device, filter: ErrorFilter) void;
    pub const pushErrorScope = wgpuDevicePushErrorScope;
    extern fn wgpuDeviceSetDeviceLostCallback(device: *Device, callback: *const DeviceLostCallback, userdata: ?*anyopaque) void;
    pub const setDeviceLostCallback = wgpuDeviceSetDeviceLostCallback;
    extern fn wgpuDeviceSetLabel(device: *Device, label: [*:0]const u8) void;
    pub const setLabel = wgpuDeviceSetLabel;
    extern fn wgpuDeviceSetUncapturedErrorCallback(device: *Device, callback: *const ErrorCallback, userdata: ?*anyopaque) void;
    pub const setUncapturedErrorCallback = wgpuDeviceSetUncapturedErrorCallback;
};

pub const Instance = opaque {
    extern fn wgpuInstanceCreateSurface(instance: *Instance, descriptor: *const SurfaceDescriptor) *Surface;
    pub const createSurface = wgpuInstanceCreateSurface;
    extern fn wgpuInstanceRequestAdapter(instance: *Instance, options: ?*const RequestAdapterOptions, callback: *const RequestAdapterCallback, userdata: ?*anyopaque) void;
    pub const requestAdapter = wgpuInstanceRequestAdapter;
};

pub const PipelineLayout = opaque {
    extern fn wgpuPipelineLayoutSetLabel(pipeline_layout: *PipelineLayout, label: [*:0]const u8) void;
    pub const setLabel = wgpuPipelineLayoutSetLabel;
};

pub const QuerySet = opaque {
    extern fn wgpuQuerySetDestroy(query_set: *QuerySet) void;
    pub const destroy = wgpuQuerySetDestroy;
    extern fn wgpuQuerySetGetCount(query_set: *QuerySet) u32;
    pub const getCount = wgpuQuerySetGetCount;
    extern fn wgpuQuerySetGetType(query_set: *QuerySet) QueryType;
    pub const getType = wgpuQuerySetGetType;
    extern fn wgpuQuerySetSetLabel(query_set: *QuerySet, label: [*:0]const u8) void;
    pub const setLabel = wgpuQuerySetSetLabel;
};

pub const Queue = opaque {
    extern fn wgpuQueueOnSubmittedWorkDone(queue: *Queue, signal_value: u64, callback: *const QueueWorkDoneCallback, userdata: ?*anyopaque) void;
    pub const onSubmittedWorkDone = wgpuQueueOnSubmittedWorkDone;
    extern fn wgpuQueueSetLabel(queue: *Queue, label: [*:0]const u8) void;
    pub const setLabel = wgpuQueueSetLabel;
    extern fn wgpuQueueSubmit(queue: *Queue, command_count: u32, commands: [*]const *CommandBuffer) void;
    pub const submit = wgpuQueueSubmit;
    extern fn wgpuQueueWriteBuffer(queue: *Queue, buffer: *Buffer, buffer_offset: u64, data: *const anyopaque, size: usize) void;
    pub const writeBuffer = wgpuQueueWriteBuffer;
    extern fn wgpuQueueWriteTexture(queue: *Queue, destination: *const ImageCopyTexture, data: *const anyopaque, data_size: usize, data_layout: *const TextureDataLayout, write_size: *const Extent3D) void;
    pub const writeTexture = wgpuQueueWriteTexture;
};

pub const RenderBundle = opaque {};

pub const RenderBundleEncoder = opaque {
    extern fn wgpuRenderBundleEncoderDraw(render_bundle_encoder: *RenderBundleEncoder, vertex_count: u32, instance_count: u32, first_vertex: u32, first_instance: u32) void;
    pub const draw = wgpuRenderBundleEncoderDraw;
    extern fn wgpuRenderBundleEncoderDrawIndexed(render_bundle_encoder: *RenderBundleEncoder, index_count: u32, instance_count: u32, first_index: u32, base_vertex: i32, first_instance: u32) void;
    pub const drawIndexed = wgpuRenderBundleEncoderDrawIndexed;
    extern fn wgpuRenderBundleEncoderDrawIndexedIndirect(render_bundle_encoder: *RenderBundleEncoder, indirect_buffer: *Buffer, indirect_offset: u64) void;
    pub const drawIndexedIndirect = wgpuRenderBundleEncoderDrawIndexedIndirect;
    extern fn wgpuRenderBundleEncoderDrawIndirect(render_bundle_encoder: *RenderBundleEncoder, indirect_buffer: *Buffer, indirect_offset: u64) void;
    pub const drawIndirect = wgpuRenderBundleEncoderDrawIndirect;
    extern fn wgpuRenderBundleEncoderFinish(render_bundle_encoder: *RenderBundleEncoder, descriptor: *const RenderBundleDescriptor) *RenderBundle;
    pub const finish = wgpuRenderBundleEncoderFinish;
    extern fn wgpuRenderBundleEncoderInsertDebugMarker(render_bundle_encoder: *RenderBundleEncoder, marker_label: [*:0]const u8) void;
    pub const insertDebugMarker = wgpuRenderBundleEncoderInsertDebugMarker;
    extern fn wgpuRenderBundleEncoderPopDebugGroup(render_bundle_encoder: *RenderBundleEncoder) void;
    pub const popDebugGroup = wgpuRenderBundleEncoderPopDebugGroup;
    extern fn wgpuRenderBundleEncoderPushDebugGroup(render_bundle_encoder: *RenderBundleEncoder, group_label: [*:0]const u8) void;
    pub const pushDebugGroup = wgpuRenderBundleEncoderPushDebugGroup;
    extern fn wgpuRenderBundleEncoderSetBindGroup(render_bundle_encoder: *RenderBundleEncoder, group_index: u32, group: *BindGroup, dynamic_offset_count: u32, dynamic_offsets: [*]const u32) void;
    pub const setBindGroup = wgpuRenderBundleEncoderSetBindGroup;
    extern fn wgpuRenderBundleEncoderSetIndexBuffer(render_bundle_encoder: *RenderBundleEncoder, buffer: *Buffer, format: IndexFormat, offset: u64, size: u64) void;
    pub const setIndexBuffer = wgpuRenderBundleEncoderSetIndexBuffer;
    extern fn wgpuRenderBundleEncoderSetLabel(render_bundle_encoder: *RenderBundleEncoder, label: [*:0]const u8) void;
    pub const setLabel = wgpuRenderBundleEncoderSetLabel;
    extern fn wgpuRenderBundleEncoderSetPipeline(render_bundle_encoder: *RenderBundleEncoder, pipeline: *RenderPipeline) void;
    pub const setPipeline = wgpuRenderBundleEncoderSetPipeline;
    extern fn wgpuRenderBundleEncoderSetVertexBuffer(render_bundle_encoder: *RenderBundleEncoder, slot: u32, buffer: *Buffer, offset: u64, size: u64) void;
    pub const setVertexBuffer = wgpuRenderBundleEncoderSetVertexBuffer;
};

pub const RenderPassEncoder = opaque {
    extern fn wgpuRenderPassEncoderBeginOcclusionQuery(render_pass: *RenderPassEncoder, query_index: u32) void;
    pub const beginOcclusionQuery = wgpuRenderPassEncoderBeginOcclusionQuery;
    extern fn wgpuRenderPassEncoderDraw(render_pass: *RenderPassEncoder, vertex_count: u32, instance_count: u32, first_vertex: u32, first_instance: u32) void;
    pub const draw = wgpuRenderPassEncoderDraw;
    extern fn wgpuRenderPassEncoderDrawIndexed(render_pass: *RenderPassEncoder, index_count: u32, instance_count: u32, first_index: u32, base_vertex: i32, first_instance: u32) void;
    pub const drawIndexed = wgpuRenderPassEncoderDrawIndexed;
    extern fn wgpuRenderPassEncoderDrawIndexedIndirect(render_pass: *RenderPassEncoder, indirect_buffer: *Buffer, indirect_offset: u64) void;
    pub const drawIndexedIndirect = wgpuRenderPassEncoderDrawIndexedIndirect;
    extern fn wgpuRenderPassEncoderDrawIndirect(render_pass: *RenderPassEncoder, indirect_buffer: *Buffer, indirect_offset: u64) void;
    pub const drawIndirect = wgpuRenderPassEncoderDrawIndirect;
    extern fn wgpuRenderPassEncoderEnd(render_pass: *RenderPassEncoder) void;
    pub const end = wgpuRenderPassEncoderEnd;
    extern fn wgpuRenderPassEncoderEndOcclusionQuery(render_pass: *RenderPassEncoder) void;
    pub const endOcclusionQuery = wgpuRenderPassEncoderEndOcclusionQuery;
    // extern fn wgpuRenderPassEncoderEndPass(render_pass: *RenderPassEncoder) void; // deprecated
    // pub const endPass = wgpuRenderPassEncoderEndPass;
    extern fn wgpuRenderPassEncoderExecuteBundles(render_pass: *RenderPassEncoder, bundle_count: u32, bundles: [*]const *RenderBundle) void;
    pub const executeBundles = wgpuRenderPassEncoderExecuteBundles;
    extern fn wgpuRenderPassEncoderInsertDebugMarker(render_pass: *RenderPassEncoder, marker_label: ?[*:0]const u8) void;
    pub const insertDebugMarker = wgpuRenderPassEncoderInsertDebugMarker;
    extern fn wgpuRenderPassEncoderPopDebugGroup(render_pass: *RenderPassEncoder) void;
    pub const popDebugGroup = wgpuRenderPassEncoderPopDebugGroup;
    extern fn wgpuRenderPassEncoderPushDebugGroup(render_pass: *RenderPassEncoder, group_label: ?[*:0]const u8) void;
    pub const pushDebugGroup = wgpuRenderPassEncoderPushDebugGroup;
    extern fn wgpuRenderPassEncoderSetBindGroup(render_pass: *RenderPassEncoder, group_index: u32, group: *BindGroup, dynamic_offset_count: u32, dynamic_offsets: [*]const u32) void;
    pub const setBindGroup = wgpuRenderPassEncoderSetBindGroup;
    extern fn wgpuRenderPassEncoderSetBlendConstant(render_pass: *RenderPassEncoder, color: *const Color) void;
    pub const setBlendConstant = wgpuRenderPassEncoderSetBlendConstant;
    extern fn wgpuRenderPassEncoderSetIndexBuffer(render_pass: *RenderPassEncoder, buffer: *Buffer, format: IndexFormat, offset: u64, size: u64) void;
    pub const setIndexBuffer = wgpuRenderPassEncoderSetIndexBuffer;
    extern fn wgpuRenderPassEncoderSetLabel(render_pass: *RenderPassEncoder, label: [*:0]const u8) void;
    pub const setLabel = wgpuRenderPassEncoderSetLabel;
    extern fn wgpuRenderPassEncoderSetPipeline(render_pass: *RenderPassEncoder, pipeline: *RenderPipeline) void;
    pub const setPipeline = wgpuRenderPassEncoderSetPipeline;
    extern fn wgpuRenderPassEncoderSetScissorRect(render_pass: *RenderPassEncoder, x: u32, y: u32, width: u32, height: u32) void;
    pub const setScissorRect = wgpuRenderPassEncoderSetScissorRect;
    extern fn wgpuRenderPassEncoderSetStencilReference(render_pass: *RenderPassEncoder, reference: u32) void;
    pub const setStencilReference = wgpuRenderPassEncoderSetStencilReference;
    extern fn wgpuRenderPassEncoderSetVertexBuffer(render_pass: *RenderPassEncoder, slot: u32, buffer: *Buffer, offset: u64, size: u64) void;
    pub const setVertexBuffer = wgpuRenderPassEncoderSetVertexBuffer;
    extern fn wgpuRenderPassEncoderSetViewport(render_pass: *RenderPassEncoder, x: f32, y: f32, width: f32, height: f32, min_depth: f32, max_depth: f32) void;
    pub const setViewport = wgpuRenderPassEncoderSetViewport;
};

pub const RenderPipeline = opaque {
    extern fn wgpuRenderPipelineGetBindGroupLayout(render_pipeline: *RenderPipeline, group_index: u32) *BindGroupLayout;
    pub const getBindGroupLayout = wgpuRenderPipelineGetBindGroupLayout;
    extern fn wgpuRenderPipelineSetLabel(render_pipeline: *RenderPipeline, label: [*:0]const u8) void;
    pub const setLabel = wgpuRenderPipelineSetLabel;
};

pub const Sampler = opaque {
    extern fn wgpuSamplerSetLabel(sampler: *Sampler, label: [*:0]const u8) void;
    pub const setLabel = wgpuSamplerSetLabel;
};

pub const ShaderModule = opaque {
    extern fn wgpuShaderModuleGetCompilationInfo(shaderModule: *ShaderModule, callback: *const CompilationInfoCallback, userdata: ?*anyopaque) void;
    pub const getCompilationInfo = wgpuShaderModuleGetCompilationInfo;
    extern fn wgpuShaderModuleSetLabel(shaderModule: *ShaderModule, label: [*:0]const u8) void;
    pub const setLabel = wgpuShaderModuleSetLabel;
};

pub const Surface = opaque {};

pub const SwapChain = opaque {
    extern fn wgpuSwapChainGetCurrentTextureView(swap_chain: *SwapChain) *TextureView;
    pub const getCurrentTextureView = wgpuSwapChainGetCurrentTextureView;
    extern fn wgpuSwapChainPresent(swap_chain: *SwapChain) void;
    pub const present = wgpuSwapChainPresent;
};

pub const Texture = opaque {
    extern fn wgpuTextureCreateView(texture: *Texture, descriptor: *const TextureViewDescriptor) *TextureView;
    pub const createView = wgpuTextureCreateView;
    extern fn wgpuTextureDestroy(texture: *Texture) void;
    pub const destroy = wgpuTextureDestroy;
    extern fn wgpuTextureGetDepthOrArrayLayers(texture: *Texture) u32;
    pub const getDepthOrArrayLayers = wgpuTextureGetDepthOrArrayLayers;
    extern fn wgpuTextureGetDimension(texture: *Texture) TextureDimension;
    pub const getDimension = wgpuTextureGetDimension;
    extern fn wgpuTextureGetFormat(texture: *Texture) TextureFormat;
    pub const getFormat = wgpuTextureGetFormat;
    extern fn wgpuTextureGetHeight(texture: *Texture) u32;
    pub const getHeight = wgpuTextureGetHeight;
    extern fn wgpuTextureGetMipLevelCount(texture: *Texture) u32;
    pub const getMipLevelCount = wgpuTextureGetMipLevelCount;
    extern fn wgpuTextureGetSampleCount(texture: *Texture) u32;
    pub const getSampleCount = wgpuTextureGetSampleCount;
    extern fn wgpuTextureGetUsage(texture: *Texture) TextureUsage;
    pub const getUsage = wgpuTextureGetUsage;
    extern fn wgpuTextureGetWidth(texture: *Texture) u32;
    pub const getWidth = wgpuTextureGetWidth;
    extern fn wgpuTextureSetLabel(texture: *Texture, label: [*:0]const u8) void;
    pub const setLabel = wgpuTextureSetLabel;
};

pub const TextureView = opaque {
    extern fn wgpuTextureViewSetLabel(texture_view: *TextureView, label: [*:0]const u8) void;
    pub const setLabel = wgpuTextureViewSetLabel;
};

pub const AdapterProperties = extern struct {
    next_in_chain: ?*anyopaque = null,
    vendor_id: u32,
    vendor_name: [*:0]const u8,
    architecture: [*:0]const u8,
    device_id: u32,
    name: [*:0]const u8,
    driver_description: [*:0]const u8,
    adapter_type: AdapterType,
    backend_type: BackendType,
};

pub const AdapterType = enum(u32) {
    discrete_gpu = 0,
    integrated_gpu = 1,
    cpu = 2,
    unknown = 3,
};

pub const AddressMode = enum(u32) {
    repeat = 0,
    mirror_repeat = 1,
    clamp_to_edge = 2,
};

pub const BackendType = enum(u32) {
    null = 0,
    webgpu = 1,
    d3d11 = 2,
    d3d12 = 3,
    metal = 4,
    vulkan = 5,
    opengl = 6,
    opengles = 7,
};

pub const BindGroupDescriptor = extern struct {
    next_in_chain: ?*const anyopaque = null,
    label: ?[*:0]const u8 = null,
    layout: *BindGroupLayout,
    entry_count: u32,
    entries: [*]const BindGroupEntry,
};

pub const BindGroupEntry = extern struct {
    next_in_chain: ?*const anyopaque = null,
    binding: u32,
    buffer: ?*Buffer = null,
    offset: u64 = 0,
    size: u64 = std.math.maxInt(u64),
    sampler: ?*Sampler = null,
    texture_view: ?*TextureView = null,
};

pub const BindGroupLayoutDescriptor = extern struct {
    next_in_chain: ?*const anyopaque = null,
    label: ?[*:0]const u8 = null,
    entry_count: u32,
    entries: [*]const BindGroupLayoutEntry,
};

pub const BindGroupLayoutEntry = extern struct {
    next_in_chain: ?*const anyopaque = null,
    binding: u32,
    visibility: ShaderStage,
    buffer: BufferBindingLayout = .{},
    sampler: SamplerBindingLayout = .{},
    texture: TextureBindingLayout = .{},
    storage_texture: StorageTextureBindingLayout = .{},
};

pub const BlendComponent = extern struct {
    operation: BlendOperation = .add,
    src_factor: BlendFactor = .one,
    dst_factor: BlendFactor = .zero,
};

pub const BlendFactor = enum(u32) {
    zero = 0,
    one = 1,
    src = 2,
    one_minus_src = 3,
    src_alpha = 4,
    one_minus_src_alpha = 5,
    dst = 6,
    one_minus_dst = 7,
    dst_alpha = 8,
    one_minus_dst_alpha = 9,
    src_alpha_saturated = 10,
    constant = 11,
    one_minus_constant = 12,
};

pub const BlendOperation = enum(u32) {
    add = 0,
    subtract = 1,
    reverse_subtract = 2,
    min = 3,
    max = 4,
};

pub const BlendState = extern struct {
    color: BlendComponent = .{},
    alpha: BlendComponent = .{},
};

pub const BufferBindingLayout = extern struct {
    next_in_chain: ?*const anyopaque = null,
    binding_type: BufferBindingType = .undef,
    has_dynamic_offset: bool = false,
    min_binding_size: u64 = 0,
};

pub const BufferBindingType = enum(u32) {
    undef = 0,
    uniform = 1,
    storage = 2,
    read_only_storage = 3,
};

pub const BufferDescriptor = extern struct {
    next_in_chain: ?*const anyopaque = null,
    label: ?[*:0]const u8 = null,
    usage: BufferUsage,
    size: u64,
    mapped_at_creation: bool = false,
};

pub const BufferMapAsyncStatus = enum(u32) {
    success = 0,
    error_ = 1,
    unknown = 2,
    device_lost = 3,
    destroyed_before_callback = 4,
    unmapped_before_callback = 5,
};

pub const BufferMapCallback = fn (status: BufferMapAsyncStatus, userdata: ?*anyopaque) callconv(.C) void;

pub const BufferMapState = enum(u32) {
    unmapped = 0,
    pending = 1,
    mapped = 2,
};

pub const BufferUsage = packed struct {
    map_read: bool = false,
    map_write: bool = false,
    copy_src: bool = false,
    copy_dst: bool = false,
    index: bool = false,
    vertex: bool = false,
    uniform: bool = false,
    storage: bool = false,
    indirect: bool = false,
    query_resolve: bool = false,
    _: u22 = 0,
};

pub const Color = extern struct {
    r: f64,
    g: f64,
    b: f64,
    a: f64,
};

pub const ColorTargetState = extern struct {
    next_in_chain: ?*const anyopaque = null,
    format: TextureFormat,
    blend: ?*const BlendState = null,
    write_mask: ColorWriteMask = ColorWriteMask.all,
};

pub const ColorWriteMask = packed struct {
    red: bool = false,
    green: bool = false,
    blue: bool = false,
    alpha: bool = false,
    _: u28 = 0,
    pub const all = ColorWriteMask{ .red = true, .green = true, .blue = true, .alpha = true };
};

pub const CommandBufferDescriptor = extern struct {
    next_in_chain: ?*const anyopaque = null,
    label: ?[*:0]const u8 = null,
};

pub const CommandEncoderDescriptor = extern struct {
    next_in_chain: ?*const anyopaque = null,
    label: ?[*:0]const u8 = null,
};

pub const CompareFunction = enum(u32) {
    undef = 0,
    never = 1,
    less = 2,
    less_equal = 3,
    greater = 4,
    greater_equal = 5,
    equal = 6,
    not_equal = 7,
    always = 8,
};

pub const CompilationInfo = extern struct {
    next_in_chain: ?*const anyopaque = null,
    message_count: u32,
    messages: [*]const CompilationMessage,
};

pub const CompilationInfoCallback = fn (status: CompilationInfoRequestStatus, compilation_info: ?*const CompilationInfo, userdata: ?*anyopaque) callconv(.C) void;

pub const CompilationInfoRequestStatus = enum(u32) {
    success = 0,
    error_ = 1,
    device_lost = 2,
    unknown = 3,
};

pub const CompilationMessage = extern struct {
    next_in_chain: ?*const anyopaque = null,
    message: ?[*:0]const u8,
    message_type: CompilationMessageType,
    line_num: u64,
    line_pos: u64,
    offset: u64,
    length: u64,
    utf16_line_pos: u64,
    utf16_offset: u64,
    utf16_length: u64,
};

pub const CompilationMessageType = enum(u32) {
    error_ = 0,
    warning = 1,
    info = 2,
};

pub const ComputePassDescriptor = extern struct {
    next_in_chain: ?*const anyopaque = null,
    label: ?[*:0]const u8 = null,
    timestamp_write_count: u32 = 0,
    timestamp_writes: [*]const ComputePassTimestampWrite = &[0]ComputePassTimestampWrite{},
};

pub const ComputePassTimestampLocation = enum(u32) {
    beginning = 0,
    end = 1,
};

pub const ComputePassTimestampWrite = extern struct {
    query_set: *QuerySet,
    query_index: u32,
    location: ComputePassTimestampLocation,
};

pub const ComputePipelineDescriptor = extern struct {
    next_in_chain: ?*const anyopaque = null,
    label: ?[*:0]const u8 = null,
    layout: ?*PipelineLayout = null,
    compute: ProgrammableStageDescriptor,
};

pub const ConstantEntry = extern struct {
    next_in_chain: ?*const anyopaque = null,
    key: [*:0]const u8,
    value: f64,
};

pub const CreateComputePipelineAsyncCallback = fn (status: CreatePipelineAsyncStatus, pipeline: ?*ComputePipeline, message: [*:0]const u8, userdata: ?*anyopaque) callconv(.C) void;

pub const CreatePipelineAsyncStatus = enum(u32) {
    success = 0,
    error_ = 1,
    device_lost = 2,
    device_destroyed = 3,
    unknown = 4,
};

pub const CreateRenderPipelineAsyncCallback = fn (status: CreatePipelineAsyncStatus, pipeline: ?*RenderPipeline, message: [*:0]const u8, userdata: ?*anyopaque) callconv(.C) void;

pub const CullMode = enum(u32) {
    none = 0,
    front = 1,
    back = 2,
};

pub const DepthStencilState = extern struct {
    next_in_chain: ?*const anyopaque = null,
    format: TextureFormat,
    depth_write_enabled: bool = false,
    depth_compare: CompareFunction = .always,
    stencil_front: StencilFaceState = .{},
    stencil_back: StencilFaceState = .{},
    stencil_read_mask: u32 = std.math.maxInt(u32),
    stencil_write_mask: u32 = std.math.maxInt(u32),
    depth_bias: i32 = 0,
    depth_bias_slope_scale: f32 = 0,
    depth_bias_clamp: f32 = 0,
};

pub const DeviceDescriptor = extern struct {
    next_in_chain: ?*const anyopaque = null,
    label: ?[*:0]const u8 = null,
    required_features_count: u32 = 0,
    required_features: [*]const FeatureName = &[0]FeatureName{},
    required_limits: ?*const RequiredLimits = null,
    default_queue: QueueDescriptor = .{},
};

pub const DeviceLostCallback = fn (reason: DeviceLostReason, message: [*:0]const u8, userdata: ?*anyopaque) callconv(.C) void;

pub const DeviceLostReason = enum(u32) {
    undef = 0,
    destroyed = 1,
};

pub const ErrorCallback = fn (error_type: ErrorType, message: [*:0]const u8, userdata: ?*anyopaque) callconv(.C) void;

pub const ErrorFilter = enum(u32) {
    validation = 0,
    out_of_memory = 1,
    internal = 2,
};

pub const ErrorType = enum(u32) {
    no_error = 0,
    validation = 1,
    out_of_memory = 2,
    internal = 3,
    unknown = 4,
    device_lost = 5,
};

pub const Extent3D = extern struct {
    width: u32,
    height: u32 = 1,
    depth_or_array_layers: u32 = 1,
};

pub const FeatureName = enum(u32) {
    undef = 0,
    depth_clip_control = 1,
    depth32_float_stencil8 = 2,
    timestamp_query = 3,
    pipeline_statistics_query = 4,
    texture_compression_bc = 5,
    texture_compression_etc2 = 6,
    texture_compression_astc = 7,
    indirect_first_instance = 8,
    shader_f16 = 9,
    rg11b10_ufloat_renderable = 10,
    dawn_shader_float16 = 1001, // dawn
    dawn_internal_usages = 1002, // dawn
    dawn_multi_planar_formats = 1003, // dawn
    dawn_native = 1004, // dawn
    chromium_experimental_dp4a = 1005, // dawn
    timestamp_query_inside_passes = 1006, // dawn
};

pub const FilterMode = enum(u32) {
    nearest = 0,
    linear = 1,
};

pub const FragmentState = extern struct {
    next_in_chain: ?*const anyopaque = null,
    module: *ShaderModule,
    entry_point: [*:0]const u8,
    constant_count: u32 = 0,
    constants: [*]const ConstantEntry = &[0]ConstantEntry{},
    target_count: u32,
    targets: [*]const ColorTargetState,
};

pub const FrontFace = enum(u32) {
    ccw = 0,
    cw = 1,
};

pub const ImageCopyBuffer = extern struct {
    next_in_chain: ?*const anyopaque = null,
    layout: TextureDataLayout = .{},
    buffer: *Buffer,
};

pub const ImageCopyTexture = extern struct {
    next_in_chain: ?*const anyopaque = null,
    texture: *Texture,
    mip_level: u32 = 0,
    origin: Origin3D = .{},
    aspect: TextureAspect = .all,
};

pub const IndexFormat = enum(u32) {
    undef = 0,
    uint16 = 1,
    uint32 = 2,
};

pub const InstanceDescriptor = extern struct {
    next_in_chain: ?*const anyopaque = null,
};

pub const Limits = extern struct {
    max_texture_dimension1d: u32 = std.math.maxInt(u32),
    max_texture_dimension2d: u32 = std.math.maxInt(u32),
    max_texture_dimension3d: u32 = std.math.maxInt(u32),
    max_texture_array_layers: u32 = std.math.maxInt(u32),
    max_bind_groups: u32 = std.math.maxInt(u32),
    max_bindings_per_bind_group: u32 = std.math.maxInt(u32),
    max_dynamic_uniform_buffers_per_pipeline_layout: u32 = std.math.maxInt(u32),
    max_dynamic_storage_buffers_per_pipeline_layout: u32 = std.math.maxInt(u32),
    max_sampled_textures_per_shader_stage: u32 = std.math.maxInt(u32),
    max_samplers_per_shader_stage: u32 = std.math.maxInt(u32),
    max_storage_buffers_per_shader_stage: u32 = std.math.maxInt(u32),
    max_storage_textures_per_shader_stage: u32 = std.math.maxInt(u32),
    max_uniform_buffers_per_shader_stage: u32 = std.math.maxInt(u32),
    max_uniform_buffer_binding_size: u64 = std.math.maxInt(u64),
    max_storage_buffer_binding_size: u64 = std.math.maxInt(u64),
    min_uniform_buffer_offset_alignment: u32 = std.math.maxInt(u32),
    min_storage_buffer_offset_alignment: u32 = std.math.maxInt(u32),
    max_vertex_buffers: u32 = std.math.maxInt(u32),
    max_buffer_size: u64 = std.math.maxInt(u64),
    max_vertex_attributes: u32 = std.math.maxInt(u32),
    max_vertex_buffer_array_stride: u32 = std.math.maxInt(u32),
    max_inter_stage_shader_components: u32 = std.math.maxInt(u32),
    max_inter_stage_shader_variables: u32 = std.math.maxInt(u32),
    max_color_attachments: u32 = std.math.maxInt(u32),
    max_color_attachment_bytes_per_sample: u32 = std.math.maxInt(u32),
    max_compute_workgroup_storage_size: u32 = std.math.maxInt(u32),
    max_compute_invocations_per_workgroup: u32 = std.math.maxInt(u32),
    max_compute_workgroup_size_x: u32 = std.math.maxInt(u32),
    max_compute_workgroup_size_y: u32 = std.math.maxInt(u32),
    max_compute_workgroup_size_z: u32 = std.math.maxInt(u32),
    max_compute_workgroups_per_dimension: u32 = std.math.maxInt(u32),
};

pub const LoadOp = enum(u32) {
    undef = 0,
    clear = 1,
    load = 2,
};

pub const MapMode = packed struct {
    read: bool = false,
    write: bool = false,
    _: u30 = 0,
};

pub const MultisampleState = extern struct {
    next_in_chain: ?*const anyopaque = null,
    count: u32 = 1,
    mask: u32 = std.math.maxInt(u32),
    alpha_to_coverage_enabled: bool = false,
};

pub const Origin3D = extern struct {
    x: u32 = 0,
    y: u32 = 0,
    z: u32 = 0,
};

pub const PipelineLayoutDescriptor = extern struct {
    next_in_chain: ?*const anyopaque = null,
    label: ?[*:0]const u8 = null,
    bind_group_layout_count: u32,
    bind_group_layouts: [*]const *BindGroupLayout,
};

pub const PipelineStatisticName = enum(u32) {
    vertex_shader_invocations = 0,
    clipper_invocations = 1,
    clipper_primitives_out = 2,
    fragment_shader_invocations = 3,
    compute_shader_invocations = 4,
};

pub const PowerPreference = enum(u32) {
    undef = 0,
    low_power = 1,
    high_performance = 2,
};

pub const PresentMode = enum(u32) {
    immediate = 0,
    mailbox = 1,
    fifo = 2,
};

pub const PrimitiveState = extern struct {
    next_in_chain: ?*const anyopaque = null,
    topology: PrimitiveTopology = .triangle_list,
    strip_index_format: IndexFormat = .undef,
    front_face: FrontFace = .ccw,
    cull_mode: CullMode = .none,
};

pub const PrimitiveTopology = enum(u32) {
    point_list = 0,
    line_list = 1,
    line_strip = 2,
    triangle_list = 3,
    triangle_strip = 4,
};

pub const Proc = fn () callconv(.C) void;

pub const ProgrammableStageDescriptor = extern struct {
    next_in_chain: ?*const anyopaque = null,
    module: *ShaderModule,
    entry_point: [*:0]const u8,
    constant_count: u32 = 0,
    constants: [*]const ConstantEntry = &[0]ConstantEntry{},
};

pub const QuerySetDescriptor = extern struct {
    next_in_chain: ?*const anyopaque = null,
    label: ?[*:0]const u8 = null,
    query_type: QueryType,
    count: u32,
    pipeline_statistics: [*]const PipelineStatisticName = &[0]PipelineStatisticName{},
    pipeline_statistics_count: u32 = 0,
};

pub const QueryType = enum(u32) {
    occlusion = 0,
    pipeline_statistics = 1,
    timestamp = 2,
};

pub const QueueDescriptor = extern struct {
    next_in_chain: ?*const anyopaque = null,
    label: ?[*:0]const u8 = null,
};

pub const QueueWorkDoneCallback = fn (status: QueueWorkDoneStatus, userdata: ?*anyopaque) callconv(.C) void;

pub const QueueWorkDoneStatus = enum(u32) {
    success = 0,
    error_ = 1,
    unknown = 2,
    device_lost = 3,
};

pub const RenderBundleDescriptor = extern struct {
    next_in_chain: ?*const anyopaque = null,
    label: ?[*:0]const u8 = null,
};

pub const RenderBundleEncoderDescriptor = extern struct {
    next_in_chain: ?*const anyopaque = null,
    label: ?[*:0]const u8 = null,
    color_formats_count: u32,
    color_formats: [*]const TextureFormat,
    depth_stencil_format: TextureFormat = .undef,
    sample_count: u32 = 1,
    depth_read_only: bool = false,
    stencil_read_only: bool = false,
};

pub const RenderPassColorAttachment = extern struct {
    view: ?*TextureView = null,
    resolve_target: ?*TextureView = null,
    load_op: LoadOp,
    store_op: StoreOp,
    clear_color: Color = .{ .r = std.math.nan(f64), .g = std.math.nan(f64), .b = std.math.nan(f64), .a = std.math.nan(f64) }, // deprecated
    clear_value: Color,
};

pub const RenderPassDepthStencilAttachment = extern struct {
    view: *TextureView,
    depth_load_op: LoadOp = .undef,
    depth_store_op: StoreOp = .undef,
    clear_depth: f32 = std.math.nan(f32), // deprecated
    depth_clear_value: f32 = 0,
    depth_read_only: bool = false,
    stencil_load_op: LoadOp = .undef,
    stencil_store_op: StoreOp = .undef,
    clear_stencil: u32 = 0, // deprecated
    stencil_clear_value: u32 = 0,
    stencil_read_only: bool = false,
};

pub const RenderPassDescriptor = extern struct {
    next_in_chain: ?*const anyopaque = null,
    label: ?[*:0]const u8 = null,
    color_attachment_count: u32,
    color_attachments: [*]const RenderPassColorAttachment,
    depth_stencil_attachment: ?*const RenderPassDepthStencilAttachment = null,
    occlusion_query_set: ?*QuerySet = null,
    timestamp_write_count: u32 = 0,
    timestamp_writes: [*]const RenderPassTimestampWrite = &[0]RenderPassTimestampWrite{},
};

pub const RenderPassTimestampLocation = enum(u32) {
    beginning = 0,
    end = 1,
};

pub const RenderPassTimestampWrite = extern struct {
    query_set: *QuerySet,
    query_index: u32,
    location: RenderPassTimestampLocation,
};

pub const RenderPipelineDescriptor = extern struct {
    next_in_chain: ?*const anyopaque = null,
    label: ?[*:0]const u8 = null,
    layout: ?*PipelineLayout = null,
    vertex: VertexState,
    primitive: PrimitiveState = .{},
    depth_stencil: ?*const DepthStencilState = null,
    multisample: MultisampleState = .{},
    fragment: ?*const FragmentState = null,
};

pub const RequestAdapterCallback = fn (status: RequestAdapterStatus, adapter: ?*Adapter, message: [*:0]const u8, userdata: ?*anyopaque) callconv(.C) void;

pub const RequestAdapterOptions = extern struct {
    next_in_chain: ?*const anyopaque = null,
    compatible_surface: ?*Surface = null,
    power_preference: PowerPreference = .undef,
    force_fallback_adapter: bool = false,
};

pub const RequestAdapterStatus = enum(u32) {
    success = 0,
    unavailable = 1,
    error_ = 2,
    unknown = 3,
};

pub const RequestDeviceCallback = fn (status: RequestDeviceStatus, device: ?*Device, message: [*:0]const u8, userdata: ?*anyopaque) callconv(.C) void;

pub const RequestDeviceStatus = enum(u32) {
    success = 0,
    error_ = 1,
    unknown = 2,
};

pub const RequiredLimits = extern struct {
    next_in_chain: ?*const anyopaque = null,
    limits: Limits = .{},
};

pub const SamplerBindingLayout = extern struct {
    next_in_chain: ?*const anyopaque = null,
    binding_type: SamplerBindingType = .undef,
};

pub const SamplerBindingType = enum(u32) {
    undef = 0,
    filtering = 1,
    non_filtering = 2,
    comparison = 3,
};

pub const SamplerDescriptor = extern struct {
    next_in_chain: ?*const anyopaque = null,
    label: ?[*:0]const u8 = null,
    address_mode_u: AddressMode = .clamp_to_edge,
    address_mode_v: AddressMode = .clamp_to_edge,
    address_mode_w: AddressMode = .clamp_to_edge,
    mag_filter: FilterMode = .nearest,
    min_filter: FilterMode = .nearest,
    mipmap_filter: FilterMode = .nearest,
    lod_min_clamp: f32 = 0,
    lod_max_clamp: f32 = 1000,
    compare: CompareFunction = .undef,
    max_anisotropy: u16 = 1,
};

pub const ShaderModuleDescriptor = extern struct {
    next_in_chain: ?*const anyopaque = null,
    label: ?[*:0]const u8 = null,
};

pub const ShaderStage = packed struct {
    vertex: bool = false,
    fragment: bool = false,
    compute: bool = false,
    _: u29 = 0,
};

pub const StencilFaceState = extern struct {
    compare: CompareFunction = .always,
    fail_op: StencilOperation = .keep,
    depth_fail_op: StencilOperation = .keep,
    pass_op: StencilOperation = .keep,
};

pub const StencilOperation = enum(u32) {
    keep = 0,
    zero = 1,
    replace = 2,
    invert = 3,
    increment_clamp = 4,
    decrement_clamp = 5,
    increment_wrap = 6,
    decrement_wrap = 7,
};

pub const StorageTextureAccess = enum(u32) {
    undef = 0,
    write_only = 1,
};

pub const StorageTextureBindingLayout = extern struct {
    next_in_chain: ?*const anyopaque = null,
    access: StorageTextureAccess = .undef,
    format: TextureFormat = .undef,
    view_dimension: TextureViewDimension = .undef,
};

pub const StoreOp = enum(u32) {
    undef = 0,
    store = 1,
    discard = 2,
};

pub const SupportedLimits = extern struct {
    next_in_chain: ?*anyopaque = null,
    limits: Limits,
};

pub const SurfaceDescriptor = extern struct {
    next_in_chain: ?*const anyopaque = null,
    label: ?[*:0]const u8 = null,
};

pub const SwapChainDescriptor = extern struct {
    next_in_chain: ?*const anyopaque = null,
    label: ?[*:0]const u8 = null,
    usage: TextureUsage,
    format: TextureFormat,
    width: u32,
    height: u32,
    present_mode: PresentMode,
    implementation: u64 = 0, // deprecated
};

pub const TextureAspect = enum(u32) {
    all = 0,
    stencil_only = 1,
    depth_only = 2,
    plane0_only = 3, // dawn
    plane1_only = 4, // dawn
};

pub const TextureBindingLayout = extern struct {
    next_in_chain: ?*const anyopaque = null,
    sample_type: TextureSampleType = .undef,
    view_dimension: TextureViewDimension = .undef,
    multisampled: bool = false,
};

pub const TextureComponentType = enum(u32) {
    float = 0,
    sint = 1,
    uint = 2,
    depth_comparison = 3,
};

pub const TextureDataLayout = extern struct {
    next_in_chain: ?*const anyopaque = null,
    offset: u64 = 0,
    bytes_per_row: u32 = std.math.maxInt(u32),
    rows_per_image: u32 = std.math.maxInt(u32),
};

pub const TextureDescriptor = extern struct {
    next_in_chain: ?*const anyopaque = null,
    label: ?[*:0]const u8 = null,
    usage: TextureUsage,
    dimension: TextureDimension = ._2d,
    size: Extent3D,
    format: TextureFormat,
    mip_level_count: u32 = 1,
    sample_count: u32 = 1,
    view_format_count: u32 = 0,
    view_formats: [*]const TextureFormat = &[0]TextureFormat{},
};

pub const TextureDimension = enum(u32) {
    _1d = 0,
    _2d = 1,
    _3d = 2,
};

pub const TextureFormat = enum(u32) {
    undef = 0,
    r8_unorm = 1,
    r8_snorm = 2,
    r8_uint = 3,
    r8_sint = 4,
    r16_uint = 5,
    r16_sint = 6,
    r16_float = 7,
    rg8_unorm = 8,
    rg8_snorm = 9,
    rg8_uint = 10,
    rg8_sint = 11,
    r32_float = 12,
    r32_uint = 13,
    r32_sint = 14,
    rg16_uint = 15,
    rg16_sint = 16,
    rg16_float = 17,
    rgba8_unorm = 18,
    rgba8_unorm_srgb = 19,
    rgba8_snorm = 20,
    rgba8_uint = 21,
    rgba8_sint = 22,
    bgra8_unorm = 23,
    bgra8_unorm_srgb = 24,
    rgb10_a2_unorm = 25,
    rg11_b10_ufloat = 26,
    rgb9_e5_ufloat = 27,
    rg32_float = 28,
    rg32_uint = 29,
    rg32_sint = 30,
    rgba16_uint = 31,
    rgba16_sint = 32,
    rgba16_float = 33,
    rgba32_float = 34,
    rgba32_uint = 35,
    rgba32_sint = 36,
    stencil8 = 37,
    depth16_unorm = 38,
    depth24_plus = 39,
    depth24_plus_stencil8 = 40,
    depth32_float = 41,
    depth32_float_stencil8 = 42,
    bc1_rgba_unorm = 43,
    bc1_rgba_unorm_srgb = 44,
    bc2_rgba_unorm = 45,
    bc2_rgba_unorm_srgb = 46,
    bc3_rgba_unorm = 47,
    bc3_rgba_unorm_srgb = 48,
    bc4_r_unorm = 49,
    bc4_r_snorm = 50,
    bc5_rg_unorm = 51,
    bc5_rg_snorm = 52,
    bc6h_rgb_ufloat = 53,
    bc6h_rgb_float = 54,
    bc7_rgba_unorm = 55,
    bc7_rgba_unorm_srgb = 56,
    etc2_rgb8_unorm = 57,
    etc2_rgb8_unorm_srgb = 58,
    etc2_rgb8a1_unorm = 59,
    etc2_rgb8a1_unorm_srgb = 60,
    etc2_rgba8_unorm = 61,
    etc2_rgba8_unorm_srgb = 62,
    eac_r11_unorm = 63,
    eac_r11_snorm = 64,
    eac_rg11_unorm = 65,
    eac_rg11_snorm = 66,
    astc_4x4_unorm = 67,
    astc_4x4_unorm_srgb = 68,
    astc_5x4_unorm = 69,
    astc_5x4_unorm_srgb = 70,
    astc_5x5_unorm = 71,
    astc_5x5_unorm_srgb = 72,
    astc_6x5_unorm = 73,
    astc_6x5_unorm_srgb = 74,
    astc_6x6_unorm = 75,
    astc_6x6_unorm_srgb = 76,
    astc_8x5_unorm = 77,
    astc_8x5_unorm_srgb = 78,
    astc_8x6_unorm = 79,
    astc_8x6_unorm_srgb = 80,
    astc_8x8_unorm = 81,
    astc_8x8_unorm_srgb = 82,
    astc_10x5_unorm = 83,
    astc_10x5_unorm_srgb = 84,
    astc_10x6_unorm = 85,
    astc_10x6_unorm_srgb = 86,
    astc_10x8_unorm = 87,
    astc_10x8_unorm_srgb = 88,
    astc_10x10_unorm = 89,
    astc_10x10_unorm_srgb = 90,
    astc_12x10_unorm = 91,
    astc_12x10_unorm_srgb = 92,
    astc_12x12_unorm = 93,
    astc_12x12_unorm_srgb = 94,
    r8_bg8_biplanar_420_unorm = 95, // dawn
};

pub const TextureSampleType = enum(u32) {
    undef = 0,
    float = 1,
    unfilterable_float = 2,
    depth = 3,
    sint = 4,
    uint = 5,
};

pub const TextureUsage = packed struct {
    copy_src: bool = false,
    copy_dst: bool = false,
    texture_binding: bool = false,
    storage_binding: bool = false,
    render_attachment: bool = false,
    present: bool = false, // dawn
    _: u26 = 0,
};

pub const TextureViewDescriptor = extern struct {
    next_in_chain: ?*const anyopaque = null,
    label: ?[*:0]const u8 = null,
    format: TextureFormat = .undef,
    dimension: TextureViewDimension = .undef,
    base_mip_level: u32 = 0,
    mip_level_count: u32 = std.math.maxInt(u32),
    base_array_layer: u32 = 0,
    array_layer_count: u32 = std.math.maxInt(u32),
    aspect: TextureAspect = .all,
};

pub const TextureViewDimension = enum(u32) {
    undef = 0,
    _1d = 1,
    _2d = 2,
    _2d_array = 3,
    cube = 4,
    cube_array = 5,
    _3d = 6,
};

pub const VertexAttribute = extern struct {
    format: VertexFormat,
    offset: u64,
    shader_location: u32,
};

pub const VertexBufferLayout = extern struct {
    array_stride: u64,
    step_mode: VertexStepMode = .vertex,
    attribute_count: u32,
    attributes: [*]const VertexAttribute,
};

pub const VertexFormat = enum(u32) {
    undef = 0,
    uint8x2 = 1,
    uint8x4 = 2,
    sint8x2 = 3,
    sint8x4 = 4,
    unorm8x2 = 5,
    unorm8x4 = 6,
    snorm8x2 = 7,
    snorm8x4 = 8,
    uint16x2 = 9,
    uint16x4 = 10,
    sint16x2 = 11,
    sint16x4 = 12,
    unorm16x2 = 13,
    unorm16x4 = 14,
    snorm16x2 = 15,
    snorm16x4 = 16,
    float16x2 = 17,
    float16x4 = 18,
    float32 = 19,
    float32x2 = 20,
    float32x3 = 21,
    float32x4 = 22,
    uint32 = 23,
    uint32x2 = 24,
    uint32x3 = 25,
    uint32x4 = 26,
    sint32 = 27,
    sint32x2 = 28,
    sint32x3 = 29,
    sint32x4 = 30,
};

pub const VertexState = extern struct {
    next_in_chain: ?*const anyopaque = null,
    module: *ShaderModule,
    entry_point: [*:0]const u8,
    constant_count: u32 = 0,
    constants: [*]const ConstantEntry = &[0]ConstantEntry{},
    buffer_count: u32 = 0,
    buffers: [*]const VertexBufferLayout = &[0]VertexBufferLayout{},
};

pub const VertexStepMode = enum(u32) {
    vertex = 0,
    instance = 1,
    vertex_buffer_not_used = 2,
};

// chains to PrimitiveState
pub const PrimitiveDepthClipControl = extern struct {
    next_in_chain: ?*const anyopaque = null,
    s_type: u32 = 7,
    unclipped_depth: bool = false,
};

// chains to RenderPassDescriptor
pub const RenderPassDescriptorMaxDrawCount = extern struct {
    next_in_chain: ?*const anyopaque = null,
    s_type: u32 = 15,
    max_draw_count: u64 = 50000000,
};

// chains to ShaderModuleDescriptor
pub const ShaderModuleSPIRVDescriptor = extern struct {
    next_in_chain: ?*const anyopaque = null,
    s_type: u32 = 5,
    code_size: u32,
    code: [*]const u32,
};

// chains to ShaderModuleDescriptor
pub const ShaderModuleWGSLDescriptor = extern struct {
    next_in_chain: ?*const anyopaque = null,
    s_type: u32 = 6,
    source: [*:0]const u8,
};

// chains to SurfaceDescriptor
pub const SurfaceDescriptorFromAndroidNativeWindow = extern struct {
    next_in_chain: ?*const anyopaque = null,
    s_type: u32 = 9,
    window: *anyopaque,
};

// chains to SurfaceDescriptor
pub const SurfaceDescriptorFromCanvasHTMLSelector = extern struct {
    next_in_chain: ?*const anyopaque = null,
    s_type: u32 = 4,
    selector: [*:0]const u8,
};

// chains to SurfaceDescriptor
pub const SurfaceDescriptorFromMetalLayer = extern struct {
    next_in_chain: ?*const anyopaque = null,
    s_type: u32 = 1,
    layer: *anyopaque,
};

// chains to SurfaceDescriptor
pub const SurfaceDescriptorFromWaylandSurface = extern struct {
    next_in_chain: ?*const anyopaque = null,
    s_type: u32 = 8,
    display: *anyopaque,
    surface: *anyopaque,
};

// chains to SurfaceDescriptor
pub const SurfaceDescriptorFromWindowsHWND = extern struct {
    next_in_chain: ?*const anyopaque = null,
    s_type: u32 = 2,
    hinstance: *anyopaque,
    hwnd: *anyopaque,
};

// chains to SurfaceDescriptor
pub const SurfaceDescriptorFromXlibWindow = extern struct {
    next_in_chain: ?*const anyopaque = null,
    s_type: u32 = 3,
    display: *anyopaque,
    window: u32,
};

pub const dawn = struct {
    pub const ExternalTexture = opaque {
        extern fn wgpuExternalTextureDestroy(external_texture: *ExternalTexture) void;
        pub const destroy = wgpuExternalTextureDestroy;
        extern fn wgpuExternalTextureSetLabel(external_texture: *ExternalTexture, label: [*:0]const u8) void;
        pub const setLabel = wgpuExternalTextureSetLabel;
    };

    pub const AlphaMode = enum(u32) {
        premultiplied = 0,
        unpremultiplied = 1,
        opaque_ = 2,
    };

    pub const CopyTextureForBrowserOptions = extern struct {
        next_in_chain: ?*const anyopaque = null,
        flip_y: bool = false,
        needs_color_space_conversion: bool = false,
        src_alpha_mode: AlphaMode = .unpremultiplied,
        src_transfer_function_parameters: ?*const [7]f32 = null,
        conversion_matrix: ?*const [9]f32 = null,
        dst_transfer_function_parameters: ?*const [7]f32 = null,
        dst_alpha_mode: AlphaMode = .unpremultiplied,
        internal_usage: bool = false,
    };

    pub const Extent2D = extern struct {
        width: u32,
        height: u32 = 1,
    };

    pub const ExternalTextureDescriptor = extern struct {
        next_in_chain: ?*const anyopaque = null,
        label: ?[*:0]const u8 = null,
        plane0: *TextureView,
        plane1: ?*TextureView = null,
        visible_origin: Origin2D,
        visible_size: Extent2D,
        do_yuv_to_rgb_conversion_only: bool = false,
        yuv_to_rgb_conversion_matrix: ?*const [12]f32 = null,
        src_transfer_function_parameters: *const [7]f32,
        dst_transfer_function_parameters: *const [7]f32,
        gamut_conversion_matrix: *const [9]f32,
        flip_y: bool = false,
        rotation: ExternalTextureRotation = .rotate_0_degrees,
    };

    pub const ExternalTextureRotation = enum(u32) {
        rotate_0_degrees = 0,
        rotate_90_degrees = 1,
        rotate_180_degrees = 2,
        rotate_270_degrees = 3,
    };

    pub const ImageCopyExternalTexture = extern struct {
        next_in_chain: ?*const anyopaque = null,
        external_texture: *ExternalTexture,
        origin: Origin3D,
    };

    pub const Origin2D = extern struct {
        x: u32 = 0,
        y: u32 = 0,
    };

    pub const LoggingCallback = fn (type: LoggingType, message: [*:0]const u8, userdata: ?*anyopaque) callconv(.C) void;

    pub const LoggingType = enum(u32) {
        verbose = 0,
        info = 1,
        warning = 2,
        error_ = 3,
    };

    // chains to AdapterProperties
    pub const DawnAdapterPropertiesPowerPreference = extern struct {
        next_in_chain: ?*anyopaque = null,
        s_type: u32 = 1006,
        power_preference: PowerPreference = .undef,
    };

    // chains to BindGroupEntry
    pub const ExternalTextureBindingEntry = extern struct {
        next_in_chain: ?*const anyopaque = null,
        s_type: u32 = 12,
        external_texture: *ExternalTexture,
    };

    // chains to BindGroupLayoutEntry
    pub const ExternalTextureBindingLayout = extern struct {
        next_in_chain: ?*const anyopaque = null,
        s_type: u32 = 13,
    };

    // chains to BufferDescriptor
    pub const DawnBufferDescriptorErrorInfoFromWireClient = extern struct {
        next_in_chain: ?*const anyopaque = null,
        s_type: u32 = 1007,
        out_of_memory: bool = false,
    };

    // chains to CommandEncoderDescriptor
    pub const DawnEncoderInternalUsageDescriptor = extern struct {
        next_in_chain: ?*const anyopaque = null,
        s_type: u32 = 1003,
        use_internal_usages: bool = false,
    };

    // chains to DeviceDescriptor
    pub const DawnCacheDeviceDescriptor = extern struct {
        next_in_chain: ?*const anyopaque = null,
        s_type: u32 = 1005,
        isolation_key: [*:0]const u8 = "",
    };

    // chains to DeviceDescriptor
    pub const DawnTogglesDeviceDescriptor = extern struct {
        next_in_chain: ?*const anyopaque = null,
        s_type: u32 = 1002,
        force_enabled_toggles_count: u32 = 0,
        force_enabled_toggles: [*]const [*:0]const u8 = &[0][*:0]const u8{},
        force_disabled_toggles_count: u32 = 0,
        force_disabled_toggles: [*]const [*:0]const u8 = &[0][*:0]const u8{},
    };

    // chains to InstanceDescriptor
    pub const DawnInstanceDescriptor = extern struct {
        next_in_chain: ?*const anyopaque = null,
        s_type: u32 = 1004,
        additional_runtime_search_paths_count: u32 = 0,
        additional_runtime_search_paths: [*]const [*:0]const u8 = &[0][*:0]const u8{},
    };

    // chains to SurfaceDescriptor
    pub const SurfaceDescriptorFromWindowsCoreWindow = extern struct {
        next_in_chain: ?*const anyopaque = null,
        s_type: u32 = 11,
        core_window: *anyopaque,
    };

    // chains to SurfaceDescriptor
    pub const SurfaceDescriptorFromWindowsSwapChainPanel = extern struct {
        next_in_chain: ?*const anyopaque = null,
        s_type: u32 = 14,
        swap_chain_panel: *anyopaque,
    };

    // chains to TextureDescriptor
    pub const DawnTextureInternalUsageDescriptor = extern struct {
        next_in_chain: ?*const anyopaque = null,
        s_type: u32 = 1000,
        internal_usage: TextureUsage = .{},
    };

    pub extern fn wgpuAdapterReference(adapter: *Adapter) void;
    pub extern fn wgpuBindGroupReference(bindGroup: *BindGroup) void;
    pub extern fn wgpuBindGroupLayoutReference(bind_group_layout: *BindGroupLayout) void;
    pub extern fn wgpuBufferReference(buffer: *Buffer) void;
    pub extern fn wgpuCommandBufferReference(command_buffer: *CommandBuffer) void;
    pub extern fn wgpuCommandEncoderReference(command_encoder: *CommandEncoder) void;
    pub extern fn wgpuComputePassEncoderReference(compute_pass_encoder: *ComputePassEncoder) void;
    pub extern fn wgpuComputePipelineReference(compute_pipeline: *ComputePipeline) void;
    pub extern fn wgpuDeviceReference(device: *Device) void;
    pub extern fn wgpuExternalTextureReference(external_texture: *ExternalTexture) void;
    pub extern fn wgpuInstanceReference(instance: *Instance) void;
    pub extern fn wgpuPipelineLayoutReference(pipeline_layout: *PipelineLayout) void;
    pub extern fn wgpuQuerySetReference(query_set: *QuerySet) void;
    pub extern fn wgpuQueueReference(queue: *Queue) void;
    pub extern fn wgpuRenderBundleReference(render_bundle: *RenderBundle) void;
    pub extern fn wgpuRenderBundleEncoderReference(render_bundle_encoder: *RenderBundleEncoder) void;
    pub extern fn wgpuRenderPassEncoderSetStencilReference(render_pass: *RenderPassEncoder, reference: u32) void;
    pub extern fn wgpuRenderPassEncoderReference(render_pass: *RenderPassEncoder) void;
    pub extern fn wgpuRenderPipelineReference(render_pipeline: *RenderPipeline) void;
    pub extern fn wgpuSamplerReference(sampler: *Sampler) void;
    pub extern fn wgpuShaderModuleReference(shaderModule: *ShaderModule) void;
    pub extern fn wgpuSurfaceReference(surface: *Surface) void;
    pub extern fn wgpuSwapChainReference(swap_chain: *SwapChain) void;
    pub extern fn wgpuTextureReference(texture: *Texture) void;
    pub extern fn wgpuTextureViewReference(texture_view: *TextureView) void;

    pub extern fn wgpuAdapterRelease(adapter: *Adapter) void;
    pub extern fn wgpuBindGroupRelease(bindGroup: *BindGroup) void;
    pub extern fn wgpuBindGroupLayoutRelease(bind_group_layout: *BindGroupLayout) void;
    pub extern fn wgpuBufferRelease(buffer: *Buffer) void;
    pub extern fn wgpuCommandBufferRelease(command_buffer: *CommandBuffer) void;
    pub extern fn wgpuCommandEncoderRelease(command_encoder: *CommandEncoder) void;
    pub extern fn wgpuComputePassEncoderRelease(compute_pass_encoder: *ComputePassEncoder) void;
    pub extern fn wgpuComputePipelineRelease(compute_pipeline: *ComputePipeline) void;
    pub extern fn wgpuDeviceRelease(device: *Device) void;
    pub extern fn wgpuExternalTextureRelease(external_texture: *ExternalTexture) void;
    pub extern fn wgpuInstanceRelease(instance: *Instance) void;
    pub extern fn wgpuPipelineLayoutRelease(pipeline_layout: *PipelineLayout) void;
    pub extern fn wgpuQuerySetRelease(query_set: *QuerySet) void;
    pub extern fn wgpuQueueRelease(queue: *Queue) void;
    pub extern fn wgpuRenderBundleRelease(render_bundle: *RenderBundle) void;
    pub extern fn wgpuRenderBundleEncoderRelease(render_bundle_encoder: *RenderBundleEncoder) void;
    pub extern fn wgpuRenderPassEncoderRelease(render_pass: *RenderPassEncoder) void;
    pub extern fn wgpuRenderPipelineRelease(render_pipeline: *RenderPipeline) void;
    pub extern fn wgpuSamplerRelease(sampler: *Sampler) void;
    pub extern fn wgpuShaderModuleRelease(shaderModule: *ShaderModule) void;
    pub extern fn wgpuSurfaceRelease(surface: *Surface) void;
    pub extern fn wgpuSwapChainRelease(swap_chain: *SwapChain) void;
    pub extern fn wgpuTextureRelease(texture: *Texture) void;
    pub extern fn wgpuTextureViewRelease(texture_view: *TextureView) void;

    pub extern fn wgpuAdapterCreateDevice(adapter: *Adapter, descriptor: *const DeviceDescriptor) *Device;
    pub extern fn wgpuCommandEncoderCopyTextureToTextureInternal(command_encoder: *CommandEncoder, source: *const ImageCopyTexture, destination: *const ImageCopyTexture, copy_size: *const Extent3D) void;
    pub extern fn wgpuCommandEncoderInjectValidationError(command_encoder: *CommandEncoder, message: [*:0]const u8) void;
    pub extern fn wgpuCommandEncoderWriteBuffer(command_encoder: *CommandEncoder, buffer: *Buffer, buffer_offset: u64, data: [*:0]const u8, size: u64) void;
    pub extern fn wgpuComputePassEncoderWriteTimestamp(compute_pass_encoder: *ComputePassEncoder, query_set: *QuerySet, query_index: u32) void;
    pub extern fn wgpuRenderPassEncoderWriteTimestamp(render_pass: *RenderPassEncoder, query_set: *QuerySet, query_index: u32) void;
    pub extern fn wgpuDeviceCreateErrorBuffer(device: *Device, descriptor: *const BufferDescriptor) *Buffer;
    pub extern fn wgpuDeviceCreateErrorExternalTexture(device: *Device) *ExternalTexture;
    pub extern fn wgpuDeviceCreateErrorTexture(device: *Device, descriptor: *const TextureDescriptor) *Texture;
    pub extern fn wgpuDeviceCreateExternalTexture(device: *Device, external_texture_descriptor: *const ExternalTextureDescriptor) *ExternalTexture;
    pub extern fn wgpuDeviceForceLoss(device: *Device, type: DeviceLostReason, message: [*:0]const u8) void;
    pub extern fn wgpuDeviceGetAdapter(device: *Device) *Adapter;
    pub extern fn wgpuDeviceInjectError(device: *Device, type: ErrorType, message: [*:0]const u8) void;
    pub extern fn wgpuDeviceSetLoggingCallback(device: *Device, callback: *const LoggingCallback, userdata: ?*anyopaque) void;
    pub extern fn wgpuDeviceTick(device: *Device) void;
    pub extern fn wgpuDeviceValidateTextureDescriptor(device: *Device, descriptor: *const TextureDescriptor) void;
    pub extern fn wgpuQueueCopyExternalTextureForBrowser(queue: *Queue, source: *const ImageCopyExternalTexture, destination: *const ImageCopyTexture, copy_size: *const Extent3D, options: *const CopyTextureForBrowserOptions) void;
    pub extern fn wgpuQueueCopyTextureForBrowser(queue: *Queue, source: *const ImageCopyTexture, destination: *const ImageCopyTexture, copy_size: *const Extent3D, options: *const CopyTextureForBrowserOptions) void;
    pub extern fn wgpuSwapChainConfigure(swap_chain: *SwapChain, format: TextureFormat, allowed_usage: TextureUsage, width: u32, height: u32) void;
};

pub const emscripten = struct {
    pub extern fn wgpuComputePassEncoderBeginPipelineStatisticsQuery(compute_pass_encoder: *ComputePassEncoder, query_set: *QuerySet, query_index: u32) void;
    pub extern fn wgpuComputePassEncoderEndPipelineStatisticsQuery(compute_pass_encoder: *ComputePassEncoder) void;
    pub extern fn wgpuInstanceProcessEvents(instance: *Instance) void;
    pub extern fn wgpuRenderPassEncoderBeginPipelineStatisticsQuery(render_pass: *RenderPassEncoder, query_index: u32) void;
    pub extern fn wgpuRenderPassEncoderEndPipelineStatisticsQuery(render_pass: *RenderPassEncoder) void;
    pub extern fn wgpuSurfaceGetPreferredFormat(surface: *Surface, adapter: *Adapter) TextureFormat;
};

const testing = std.testing;

test {
    testing.refAllDeclsRecursive(@This());
}

test {
    _ = createInstance(&.{});
}
