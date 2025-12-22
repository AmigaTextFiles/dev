echo "Compiling shaders..."
echo "----------------------------------------------------"
glslangvalidator -G -o GL_REPLACE.frag.spv 		GL_REPLACE.frag
echo "----------------------------------------------------"
glslangvalidator -G -o GL_MODULATE.frag.spv 	GL_MODULATE.frag
echo "----------------------------------------------------"
glslangvalidator -G -o GL_BLEND.frag.spv 		GL_BLEND.frag
echo "----------------------------------------------------"
glslangvalidator -G -o GL_DECAL.frag.spv 		GL_DECAL.frag
echo "----------------------------------------------------"
glslangvalidator -G -o GL_FLAT.vert.spv 		GL_FLAT.vert
echo "----------------------------------------------------"
glslangvalidator -G -o GL_UNTRANSFORMED.vert.spv 		GL_UNTRANSFORMED.vert
echo "----------------------------------------------------"
echo "Compilation done"
wait 600




