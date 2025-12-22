generic

type Element_Type is digits <>;

package matrix is

type data_type is array (Positive range <>, Positive range <>) of Element_Type;

type matrix_type ( horz : Natural; vert : Natural ) is record
data : data_type(1..horz,1..vert);
h : Natural := horz;
v : Natural := vert;
end record;

function "+"(left : matrix_type; right : matrix_type) return matrix_type;
function "-"(left : matrix_type) return matrix_type;
function "-"(left : matrix_type; right : matrix_type) return matrix_type;
function "*"(left : matrix_type; right : matrix_type) return matrix_type;
function "*"(left : Element_Type; right : matrix_type) return matrix_type;
function "*"(left : matrix_type; right : Element_Type) return matrix_type;
function "="(left : matrix_type; right : matrix_type ) return boolean;
function GetMember ( left : in matrix_type; h,v : in Integer) return Element_Type;
function Get_Horizontal ( left : in matrix_type) return Integer;
function Get_Vertical ( left : in matrix_type) return Integer;
function NewMatrix(h,v : Integer; data : data_type) return matrix_type;
procedure Assign(left : in out matrix_type; right : in matrix_type );
procedure SetMember ( left : in out matrix_type; h,v : in Integer; right : in Element_Type );
--procedure put(left : in matrix_type);

end matrix;
