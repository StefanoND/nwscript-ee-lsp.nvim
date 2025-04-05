; Parentheses
(argument_list
   "(" @delimiter
   ")" @delimiter @sentinel) @container

(parenthesized_expression
  "(" @delimiter
  ")" @delimiter @sentinel) @container

(compound_literal_expression
  "(" @delimiter
  ")" @delimiter @sentinel) @container

(parenthesized_declarator
  "(" @delimiter
  ")" @delimiter @sentinel) @container

(preproc_params
  "(" @delimiter
  ")" @delimiter @sentinel) @container

; Square brackets
(vector_specifier
  "[" @delimiter
  (number_literal) @number
  "," @delimiter
  (number_literal) @number
  "," @delimiter
  (number_literal) @number
  "]" @delimiter @sentinel) @container

(vector_specifier
  "[" @delimiter
  "]" @delimiter @sentinel) @container

; Curly brackets
(compound_statement
  "{" @delimiter
  "}" @delimiter @sentinel) @container

(initializer_list
  "{" @delimiter
  "}" @delimiter @sentinel) @container

; For loops
(for_statement
  "(" @delimiter
  ")" @delimiter @sentinel) @container
