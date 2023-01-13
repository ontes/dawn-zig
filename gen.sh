#!/bin/sh

# dawn/generator
ARGS='--template-dir dawn/generator/templates --root-dir dawn --output-dir dawn-gen'
JSON_ARGS='--dawn-json dawn/dawn.json --wire-json dawn/dawn_wire.json'

# dawn
python dawn/generator/dawn_json_generator.py $ARGS $JSON_ARGS \
    --targets headers
python dawn/generator/dawn_json_generator.py $ARGS $JSON_ARGS \
    --targets cpp_headers

# dawn/src/dawn/common
python dawn/generator/dawn_version_generator.py $ARGS \
    --dawn-dir dawn
python dawn/generator/dawn_gpu_info_generator.py $ARGS \
    --gpu-info-json dawn/src/dawn/gpu_info.json

# dawn/src/dawn/native
python dawn/generator/dawn_json_generator.py $ARGS $JSON_ARGS \
    --targets native_utils
python dawn/generator/opengl_loader_generator.py $ARGS \
    --gl-xml dawn/third_party/khronos/gl.xml \
    --supported-extensions dawn/src/dawn/native/opengl/supported_extensions.json
python dawn/generator/dawn_json_generator.py $ARGS $JSON_ARGS \
    --targets webgpu_dawn_native_proc

# spirv-tools/source
python spirv-tools/utils/generate_grammar_tables.py \
    --spirv-core-grammar spirv-headers/include/spirv/unified1/spirv.core.grammar.json \
    --extinst-debuginfo-grammar spirv-headers/include/spirv/unified1/extinst.debuginfo.grammar.json \
    --extinst-cldebuginfo100-grammar spirv-headers/include/spirv/unified1/extinst.opencl.debuginfo.100.grammar.json \
    --core-insts-output spirv-gen/core.insts-unified1.inc \
    --operand-kinds-output spirv-gen/operand.kinds-unified1.inc \
    --output-language c++
python spirv-tools/utils/generate_grammar_tables.py \
    --spirv-core-grammar spirv-headers/include/spirv/unified1/spirv.core.grammar.json \
    --extinst-debuginfo-grammar spirv-headers/include/spirv/unified1/extinst.debuginfo.grammar.json \
    --extinst-cldebuginfo100-grammar spirv-headers/include/spirv/unified1/extinst.opencl.debuginfo.100.grammar.json \
    --extension-enum-output spirv-gen/extension_enum.inc \
    --enum-string-mapping-output spirv-gen/enum_string_mapping.inc \
    --output-language c++
python spirv-tools/utils/generate_grammar_tables.py \
    --extinst-opencl-grammar spirv-headers/include/spirv/unified1/extinst.opencl.std.100.grammar.json \
    --opencl-insts-output spirv-gen/opencl.std.insts.inc
python spirv-tools/utils/generate_grammar_tables.py \
    --extinst-glsl-grammar spirv-headers/include/spirv/unified1/extinst.glsl.std.450.grammar.json \
    --glsl-insts-output spirv-gen/glsl.std.450.insts.inc \
    --output-language c++
python spirv-tools/utils/generate_grammar_tables.py \
    --extinst-vendor-grammar spirv-headers/include/spirv/unified1/extinst.spv-amd-shader-explicit-vertex-parameter.grammar.json \
    --vendor-insts-output spirv-gen/spv-amd-shader-explicit-vertex-parameter.insts.inc
python spirv-tools/utils/generate_grammar_tables.py \
    --extinst-vendor-grammar spirv-headers/include/spirv/unified1/extinst.spv-amd-shader-trinary-minmax.grammar.json \
    --vendor-insts-output spirv-gen/spv-amd-shader-trinary-minmax.insts.inc
python spirv-tools/utils/generate_grammar_tables.py \
    --extinst-vendor-grammar spirv-headers/include/spirv/unified1/extinst.spv-amd-gcn-shader.grammar.json \
    --vendor-insts-output spirv-gen/spv-amd-gcn-shader.insts.inc
python spirv-tools/utils/generate_grammar_tables.py \
    --extinst-vendor-grammar spirv-headers/include/spirv/unified1/extinst.spv-amd-shader-ballot.grammar.json \
    --vendor-insts-output spirv-gen/spv-amd-shader-ballot.insts.inc
python spirv-tools/utils/generate_grammar_tables.py \
    --extinst-vendor-grammar spirv-headers/include/spirv/unified1/extinst.debuginfo.grammar.json \
    --vendor-insts-output spirv-gen/debuginfo.insts.inc
python spirv-tools/utils/generate_grammar_tables.py \
    --extinst-vendor-grammar spirv-headers/include/spirv/unified1/extinst.opencl.debuginfo.100.grammar.json \
    --vendor-insts-output spirv-gen/opencl.debuginfo.100.insts.inc \
    --vendor-operand-kind-prefix CLDEBUG100_
python spirv-tools/utils/generate_grammar_tables.py \
    --extinst-vendor-grammar spirv-headers/include/spirv/unified1/extinst.nonsemantic.shader.debuginfo.100.grammar.json \
    --vendor-insts-output spirv-gen/nonsemantic.shader.debuginfo.100.insts.inc \
    --vendor-operand-kind-prefix SHDEBUG100_
python spirv-tools/utils/generate_grammar_tables.py \
    --extinst-vendor-grammar spirv-headers/include/spirv/unified1/extinst.nonsemantic.clspvreflection.grammar.json \
    --vendor-insts-output spirv-gen/nonsemantic.clspvreflection.insts.inc
python spirv-tools/utils/generate_language_headers.py \
    --extinst-grammar spirv-headers/include/spirv/unified1/extinst.debuginfo.grammar.json \
    --extinst-output-path spirv-gen/DebugInfo.h
python spirv-tools/utils/generate_language_headers.py \
    --extinst-grammar spirv-headers/include/spirv/unified1/extinst.opencl.debuginfo.100.grammar.json \
    --extinst-output-path spirv-gen/OpenCLDebugInfo100.h
python spirv-tools/utils/generate_language_headers.py \
    --extinst-grammar spirv-headers/include/spirv/unified1/extinst.nonsemantic.shader.debuginfo.100.grammar.json \
    --extinst-output-path spirv-gen/NonSemanticShaderDebugInfo100.h
python spirv-tools/utils/generate_registry_tables.py \
    --xml spirv-headers/include/spirv/spir-v.xml \
    --generator-output spirv-gen/generators.inc