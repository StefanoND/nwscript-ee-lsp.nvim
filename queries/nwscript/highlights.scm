; Variables
(identifier) @variable

; Control structures
[
  "if"
  "else"
  "switch"
  "case"
  "default"
] @conditional

[
  "do"
  "for"
  "while"
  "break"
  "continue"
] @repeat

; Keywords
"#include" @include
"return" @keyword.return

; Types
"struct" @type.builtin

; Operators
[
  "!"
  "."
  "--"
  "-"
  "-="
  "="
  "!="
  "%"
  "%="
  "*"
  "*="
  "/"
  "/="
  "&"
  "&&"
  "&="
  "+"
  "++"
  "+="
  "<"
  "<<"
  "<="
  "<<="
  "="
  "=="
  ">"
  ">>"
  ">>>"
  ">="
  ">>="
  ">>>="
  "|"
  "||"
  "|="
  "^"
  "^="
  "~"
] @operator

; Punctuation
[ "." ":" ","  ";"] @punctuation.delimiter
[ "(" ")" "[" "]" "{" "}"] @punctuation.bracket

; Conditional expressions
(conditional_expression [ "?" ":" ] @conditional)

(field_expression) @enum

; Constants
(const_qualifier) @type.modification

; Functions
(function_definition
  declarator: (identifier) @function)

; Structs
(struct_declarator
  declarator: (identifier) @type)
(struct_declarator
  (identifier) @type)

(struct_members
  (type_identifier) @type.builtin
  (identifier) @enum)

; Keywords
(decoration) @keyword

(struct_specifier
  (identifier) @type)
(struct_specifier) @type

; Function calls
(call_expression
  function: (identifier) @function)

; Types
(primitive_type) @type.builtin
(nwn_type) @type.builtin

; Literals
(string_literal) @string
(escape_sequence) @string.special
(number_literal) @number

; Vector
(vector_specifier [
  "["
  (number_literal) @number
  ","
  (number_literal) @number
  ","
  (number_literal) @number
  "]"
  ] @vector)
(vector_specifier) @vector

(nwn_constant) @constant.builtin
((identifier) @constant
  (#match? @constant "^[A-Z][A-Z\\d_]*$"))

; Macros
(nwnsc_macro) @macro

; Comments
(comment) @comment
