/*
 * MIT License
 *
 * Copyright(c) 2019-2020 Asif Ali
 *
 * Authors/Contributors:
 *
 * Asif Ali
 * Cedric Guillemet
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this softwareand associated documentation files(the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and /or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions :
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

#define PI        3.14159265358979323
#define TWO_PI    6.28318530717958648
#define INFINITY  1000000.0
#define EPS 0.001

// Global variables

mat4 transform;

vec4 seed;
vec3 tempTexCoords;
struct Ray { vec3 origin; vec3 direction; };
struct Material { vec4 albedo; vec4 emission; vec4 param; vec4 texIDs; };
struct Camera { vec3 up; vec3 right; vec3 forward; vec3 position; float fov; float focalDist; float aperture; };
struct Light { vec3 position; vec3 emission; vec3 u; vec3 v; vec3 radiusAreaType; };
struct State { vec3 normal; vec3 ffnormal; vec3 fhp; bool isEmitter; int depth; float hitDist; vec2 texCoord; vec3 bary; ivec3 triID; int matID; Material mat; bool specularBounce; };
struct BsdfSampleRec { vec3 bsdfDir; float pdf; };
struct LightSampleRec { vec3 surfacePos; vec3 normal; vec3 emission; float pdf; };

uniform Camera camera;

float rand()
{
	const vec4 q = vec4(1225.0, 1585.0, 2457.0, 2098.0);
	const vec4 r = vec4(1112.0, 367.0, 92.0, 265.0);
	const vec4 a = vec4(3423.0, 2646.0, 1707.0, 1999.0);
	const vec4 m = vec4(4194287.0, 4194277.0, 4194191.0, 4194167.0);

	vec4 beta = floor(seed / q);
	vec4 p = a * (seed - beta * q) - beta * r;
	beta = (sign(-p) + vec4(1.0)) * vec4(0.5) * m;
	seed = (p + beta);

	return fract(dot(seed / m, vec4(1.0, -1.0, 1.0, -1.0)));
}