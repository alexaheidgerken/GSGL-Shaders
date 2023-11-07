#version 300 es

// CSCI 4611 Assignment 5: Artistic Rendering
// Normal mapping is a complex effect that will involve changing
// both the vertex and fragment shader. This implementation is
// based on the approach described below, and you are encouraged
// to read this tutorial writeup for a deeper understanding.
// https://learnopengl.com/Advanced-Lighting/Normal-Mapping

// Most of the structure of this vertex shader has been implemented,
// but you will need to complete the code that computes the TBN matrix.

// You should complete this vertex shader first, and then move on to
// the fragment shader only after you have verified that is correct.

precision mediump int;
precision mediump float;

const int MAX_LIGHTS = 8;

uniform int numLights;
uniform vec3 lightPositions[MAX_LIGHTS];
uniform vec3 eyePosition;

uniform mat4 modelMatrix;
uniform mat4 viewMatrix;
uniform mat4 projectionMatrix;
uniform mat4 normalMatrix;

in vec3 position;
in vec3 normal;
in vec3 tangent;
in vec4 color;
in vec2 texCoord;

out vec4 vertColor;
out vec2 uv;
out vec3 tangentVertPosition;
out vec3 tangentEyePosition;
out vec3 tangentLightPositions[MAX_LIGHTS];

void main() 
{
    // Assign the vertex color and uv
    vertColor = color;
    uv = texCoord.xy; 

    // Compute the world vertex position
    vec3 worldPosition = (modelMatrix * vec4(position, 1)).xyz;   

    // TO BE ADDED
    // This line of code sets the TBN to an identity matrix.
    // You will need to replace it and compute the matrix that
    // converts vertices from world space to tangent space. 
    // When this part is completed correctly, it will produce
    // a result that looks identical to the Phong shader.
    // Then, you can move on to complete the fragment shader.
    vec3 rgb_normal = normal * 0.5 + 0.5;
    vec3 pos1(-1.0, 1.0, 0.0);
    vec3 pos2(-1.0, -1.0, 0.0);
    vec3 pos3( 1.0, -1.0, 0.0);
    vec3 pos4( 1.0,  1.0, 0.0);
// texture coordinates
    vec2 uv1(0.0, 1.0);
    vec2 uv2(0.0, 0.0);
    vec2 uv3(1.0, 0.0);
    vec2 uv4(1.0, 1.0);
// normal vector
    vec3 nm(0.0, 0.0, 1.0); 
    vec3 edge1 = pos2 - pos1;
    vec3 edge2 = pos3 - pos1;
    vec2 deltaUV1 = uv2 - uv1;
    vec2 deltaUV2 = uv3 - uv1;
    float f = 1.0f / (deltaUV1.x * deltaUV2.y - deltaUV2.x * deltaUV1.y);

    tangent1.x = f * (deltaUV2.y * edge1.x - deltaUV1.y * edge2.x);
    tangent1.y = f * (deltaUV2.y * edge1.y - deltaUV1.y * edge2.y);
    tangent1.z = f * (deltaUV2.y * edge1.z - deltaUV1.y * edge2.z);
    vec3 bitangent1 = (0.0, 0.0, 0.0);
    bitangent1.x = f * (-deltaUV2.x * edge1.x + deltaUV1.x * edge2.x);
    bitangent1.y = f * (-deltaUV2.x * edge1.y + deltaUV1.x * edge2.y);
    bitangent1.z = f * (-deltaUV2.x * edge1.z + deltaUV1.x * edge2.z);

    vec3 T = normalize(vec3(model * vec4(aTangent,   0.0)));
    vec3 B = normalize(vec3(model * vec4(aBitangent, 0.0)));
    vec3 N = normalize(vec3(model * vec4(aNormal,    0.0)));
    mat3 tbn = transpose(mat3(T, B, N));

    // Compute the tangent space vertex and view positions
    tangentVertPosition = tbn * worldPosition;
    tangentEyePosition = tbn * eyePosition;

    // Compute the tangent space light positions
    for(int i=0; i < numLights; i++)
    {
        tangentLightPositions[i] = tbn * lightPositions[i];
    }
    
    // Compute the projected vertex position
    gl_Position = projectionMatrix * viewMatrix * vec4(worldPosition, 1);
}