#include <stdarg.h>
#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>
#include <stdlib.h>


typedef struct K {
  double r;
  double g;
  double b;
} K;

typedef struct FaceNode {
  int32_t v;
  int32_t t;
  int32_t n;
} FaceNode;

typedef struct VecSwift_FaceNode {
  const struct FaceNode *data;
  size_t length;
  size_t capacity;
} VecSwift_FaceNode;

typedef struct FaceC {
  struct VecSwift_FaceNode nodes;
  int32_t smoothing_group;
  int32_t material;
} FaceC;

typedef struct PointC {
  double x;
  double y;
  double z;
} PointC;

typedef struct VecSwift_PointC {
  const struct PointC *data;
  size_t length;
  size_t capacity;
} VecSwift_PointC;

typedef struct VertexTexture {
  double u;
  double v;
} VertexTexture;

typedef struct VecSwift_VertexTexture {
  const struct VertexTexture *data;
  size_t length;
  size_t capacity;
} VecSwift_VertexTexture;

typedef struct MtlGroup {
  int32_t id;
  double ns;
  struct K ka;
  struct K kd;
  struct K ks;
  struct K ke;
  double ni;
  double d;
  double illum;
} MtlGroup;

typedef struct MtlGroupC {
  char *name;
  struct MtlGroup material;
} MtlGroupC;

typedef struct VecSwift_MtlGroupC {
  const struct MtlGroupC *data;
  size_t length;
  size_t capacity;
} VecSwift_MtlGroupC;

typedef struct VecSwift_FaceC {
  const struct FaceC *data;
  size_t length;
  size_t capacity;
} VecSwift_FaceC;

typedef struct VecSwift_i32 {
  const int32_t *data;
  size_t length;
  size_t capacity;
} VecSwift_i32;

typedef struct VertexMinMax {
  double x_min;
  double x_max;
  double y_min;
  double y_max;
  double z_min;
  double z_max;
} VertexMinMax;

typedef struct Dimensions {
  double width;
  double length;
  double depth;
} Dimensions;

typedef struct MeshC {
  struct VecSwift_PointC vertices;
  struct VecSwift_VertexTexture textures;
  struct VecSwift_PointC normals;
  struct VecSwift_MtlGroupC materials;
  struct VecSwift_FaceC faces;
  struct VecSwift_i32 smoothing_groups;
  struct VertexMinMax vertex_min_max;
  struct Dimensions dimensions;
  struct PointC center;
  double resolution;
} MeshC;

typedef struct CmdOptionsC {
  char *mode_c;
  char *obj_file_path_c;
  char *sprt_file_path_c;
  char *output_file_c;
  bool reorient;
  bool voxelize;
} CmdOptionsC;

/**
 * Send swift String appended to String it sent us
 *
 * Works in swift
 */
char *append_string_wrapper(const char *to);

/**
 * Receive swift primitive struct
 *
 * Works in swift
 */
int32_t consume_k_struct(struct K k);

/**
 * Send swift primitive c_char
 *
 * Works in swift
 */
char gen_char(void);

struct FaceC gen_face(void);

/**
 * Send swift primitive i32
 *
 * Works in swift
 */
int32_t gen_int(void);

/**
 * Send swift primitive struct
 *
 * Works in swift
 */
struct K gen_k_struct(void);

/**
 * Send swift a rust generated String
 *
 * Works in swift
 */
char *gen_string_wrapper(void);

struct MeshC load_avatar_from_disk_c(const struct CmdOptionsC *opts_c);

struct CmdOptionsC process_cmd_options_c_and_return(struct CmdOptionsC opts_c);

/**
 * Consume c-style struct passed in from swift
 * Have swift pass in "" instead of nulls.
 * Note this is pass by value.
 * TODO: create a pass by reference version
 */
void process_cmd_options_c_param(struct CmdOptionsC opts_c);

/**
 * Receive CmdOptionsC from swift
 */
int32_t process_cmd_options_c_ret_int(struct CmdOptionsC opts_c);

/**
 * Receive &CmdOptionsC from swift
 */
int32_t ref_cmd_options_c_ret_int(const struct CmdOptionsC *opts_c);

/**
 * Return CmdOptionsC to check if swift can consume
 *
 * Works in swift
 */
struct CmdOptionsC return_cmd_options_c(void);

/**
 * Vec used as pointer with length variable
 * Uses slice::from_raw_parts
 *
 * Works in swift
 */
int32_t sum_of_even(const int32_t *n, size_t len);
